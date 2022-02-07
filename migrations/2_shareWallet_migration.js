const ShareWallet = artifacts.require("ShareWallet");

module.exports = function (deployer) {
  deployer.deploy(ShareWallet);
};
