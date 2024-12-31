require("@nomicfoundation/hardhat-toolbox");
require("@nomicfoundation/hardhat-ignition");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
    solidity: "0.8.28",
    networks: {
        testnet: {
            url: "http://127.0.0.1:8545",
            chainId: 1337,
            accounts: [
                "0xdf57089febbacf7ba0bc227dafbffa9fc08a93fdc68e1e42411a14efcf23656e",
                "0x8f2a55949038a9610f50fb23b5883af3b4ecb3c3bb792cbcefbd1542c692be63",
                "0xc87509a1c067bbde78beb793e6fa76530b6382a4c0241e5e4a9ec0a0f44dc0d3",
                // "0x8f2a55949038a9610f50fb23b5883af3b4ecb3c3bb792cbcefbd1542c692be63",
                // "0xc87509a1c067bbde78beb793e6fa76530b6382a4c0241e5e4a9ec0a0f44dc0d3",
                // "0xae6ae8e5ccbfb04590405997ee2d52d2b330726137b875053c36d94e974d162f",
            ],
        },
        localnet: {
            url: "http://127.0.0.1:8546",
            chainId: 1338,
            accounts: [
                "0xdf57089febbacf7ba0bc227dafbffa9fc08a93fdc68e1e42411a14efcf23656e",
            ],
        },
    },
    ignition: {
        modules: ["./ignition/modules/Lock.js"],
    },
};
