var BestGameAuction = artifacts.require("BestGameAuction");

 module.exports = function(deployer) {
   deployer.deploy(BestGameAuction,8);
 };
