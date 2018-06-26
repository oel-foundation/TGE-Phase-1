var OPNToken = artifacts.require('./OPNToken.sol');

module.exports = async (deployer, network) => {
  deployer.deploy(OPNToken);
  console.log(`
    ---------------------------------------------------------------
    --------------------- OPN TOKEN SUCCESSFULLY DEPLOYED ---------
    ---------------------------------------------------------------
    - Contract address: ${OPNToken.address}
    ---------------------------------------------------------------
  `);
};