import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';

class Blockchain {
  
  String contractName = 'Voting';
  
  Future<DeployedContract> getContract() async {
    String abi = await rootBundle.loadString("assets/abi.json");
    String contractAddress = "0x5CEc2D39bC3ae1154d20bd8289CF350438Be5283";

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
    print(contract);
    print(function);
    print(args);
    dynamic result = await ethereumClient.sendTransaction(
      credential,
      Transaction.callContract(
        contract: contract,
        function: function,
        parameters: args,
        maxGas: 6700000,
        gasPrice: EtherAmount.inWei(BigInt.from(100000000000)),
    
      ),
      fetchChainIdFromNetworkId: true,
      chainId: null,
    );

    return result;
  }


  
  
}