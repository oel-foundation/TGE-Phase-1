/* 
* Description: Script to distribute tokens
* Author     : codeblcks@gmail.com
*/

// Load files and modules
let fs  = require('fs');
let csv = require('fast-csv');

// Set the Provider
const Web3 = require('web3');
if (typeof web3 !== 'undefined') {
    web3 = new Web3(web3.currentProvider);
} else {
    web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
}


// Contract
const contract = require('truffle-contract');
const OPNArtifacts = require('..\\build\\contracts\\OPNToken.json');
let OPNToken = contract(OPNArtifacts);

// Set Provider
OPNToken.setProvider(web3.currentProvider);
if (typeof OPNToken.currentProvider.sendAsync !== "function") {
    OPNToken.currentProvider.sendAsync = function() {
        return OPNToken.currentProvider.send.apply(
        OPNToken.currentProvider, arguments
    );
  };
}

// Address of deployed OPNToken contract
let OPNTokenAddress = process.argv.slice(2)[0];
if (!OPNTokenAddress) {
    console.log('\x1b[31m%s\x1b[0m',"Please provide the address of deployed contract");
    process.exit(1);
}
 
// tokenData array will contain the data from the CSV file 
let addressData = new Array();
let amountData  = new Array(); 

// CSV file to read
let stream = fs.createReadStream("..\\data\\distribute.csv");

console.log("***************************************************************************");
console.log("***                      Reading CSV file                               ***");

// Store data in arrays
csv.fromStream(stream, {headers : false})
    .on("data", function(data){
        let isAddress = web3.isAddress(data[0]);
        if(isAddress && data[0]!=null && data[0]!='' ) {
            addressData.push(data[0]);
            data[1] = data[1].split(',').join('');
            data[1] = parseInt(data[1]);
            amountData.push(data[1]);  
        }
    })
    .on("end", function () {
        // Remove the headers
        addressData.shift();
        amountData.shift();
        distributeTokens();
    });



// Function to distribute tokens
async function distributeTokens() {
    // Create instance of contract
    let OPNDistribute =  OPNToken.at(OPNTokenAddress);

    // Accounts and balance of token
    OPNToken.defaults({ from: web3.eth.accounts[0] });
    let balance = await web3.eth.getBalance(OPNTokenAddress, function (error, response) 
        { if (!error) console.log("Initial Balance:",response.toNumber())});
    let block = await web3.eth.getBlock("latest");
    console.log("Current block:",block);
    let currentTime = block.timestamp;
    console.log("Current block timestamp:",currentTime);

    console.log("***************************************************************************");
    console.log("***                  Performing distribution                            ***");

    try {
        for(var i = 0;i< addressData.length;i++) {
            let receipt =  await OPNDistribute.distributeTokens([addressData[i]],[amountData[i]]);
            if(receipt){  
                console.log("Distributed", amountData[i], "tokens for account:",addressData[i],"\n");
            }  else {
                console.log('\x1b[31m%s\x1b[0m',"Failed to distribute vested OPN tokens for account:",addressData[i]);
            }
        }
    } catch (err) {
        console.log(err);
    }    
    console.log("***                    Token Distribution Completed!                    ***");
    console.log("***************************************************************************");
}






























