import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';

class Blockchain {
  
  String contractName = 'Voting';
  
  Future<DeployedContract> getContract() async {
    String abi = await rootBundle.loadString("abi.json");
    String contractAddress = "0x57E73b6F1E5cd741146E96B4Bb35F93e12016Cf8";

    DeployedContract contract = DeployedContract(
      ContractAbi.fromJson(abi, contractName),
      EthereumAddress.fromHex(contractAddress),
    );

    return contract;
  }

  Future<List<dynamic>> query(String functionName, List<dynamic> args, Web3Client ethereumClient) async {
    DeployedContract contract = await getContract();
    ContractFunction function = contract.function(functionName);
    List<dynamic> result = await ethereumClient.call(
        contract: contract, function: function, params: args);
    return result;
  }

  Future<String> transaction(String functionName, List<dynamic> args, Web3Client ethereumClient, String privateKey) async {
    EthPrivateKey credential = EthPrivateKey.fromHex(privateKey);
    DeployedContract contract = await getContract();
    ContractFunction function = contract.function(functionName);
    dynamic result = await ethereumClient.sendTransaction(
      credential,
      Transaction.callContract(
        contract: contract,
        function: function,
        parameters: args,
      ),
      fetchChainIdFromNetworkId: true,
      chainId: null,
    );

    return result;
  }


  
  
}