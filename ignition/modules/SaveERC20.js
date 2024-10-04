const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");


const LSK_TokenAddress = "0x6033F7f88332B8db6ad452B7C6D5bB643990aE3f";

module.exports = buildModule("SaveERC20Module", (m) => {
  
  
  const SaveERC20 = m.contract("SaveERC20",[LSK_TokenAddress])

  return { SaveERC20};
});
