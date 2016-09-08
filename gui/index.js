//#BIOTS2016 - Lehman Brothers	
	
	//load the contract file 'hedge.sol' into 'contractFile'
	var contractFile;
	$.get('hedgeContract.sol', function(data) {
	    contractFile = data;
	});	
	
	$.get("hedgeContract.sol", function(response) {
     var logfile = response;
});

	
	//compiling the contract with web3 API
	var compiledContract = web3.eth.compile.solidity(logfile);

	var HedgeContract = web3.eth.contract(compiledContract.info.abiDefinition);
	

//	var _greeting = "Hello World!"
//	var greeterContract = web3.eth.contract(greeterCompiled.greeter.info.abiDefinition);
	
	T = maturity;
	
	console.log(web3.version.api)
	
	var createOffer_exec = createOffer_func.new(T, minThreshold, maxThreshold, valueETH, {
	    from: web3.eth.accounts[0],
	    data: compiledContract.createOffer.code,
	    gas: 300000
	}, function(e, contract) {
	    if (!e) {

	        if (!contract.address) {
	            console.log("Contract transaction send: TransactionHash: " + contract.transactionHash + " waiting to be mined...");

	        } else {
	            console.log("Contract mined! Address: " + contract.address);
	            console.log(contract);
	        }

	    }
	})