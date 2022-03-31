const Web3 = require("web3");
const web3 = new Web3(Web3.givenProvider || process.env.ENDPOINT_URL);

const { artifacts } = require("truffle");

const Store = artifacts.require("Store");
module.exports = async (deployer) => {
  const [_feeAccount] = await web3.eth.getAccounts();
  const _name = "Fresher";
  const _feePercent = 10;
  await deployer.deploy(Store, _name, _feeAccount, _feePercent);
};
