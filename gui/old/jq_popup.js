$(document).ready(function() {
	
	var contractFile; //load the contract file 'hedge.sol' into 'contractFile'
	$.get('hedge.sol', function(data){
    contractFile= data;
	});
	
	//compiling the contract with web3 API
	var compiledContract = web3.eth.compile.solidity(contractFile);
	
	var createOffer_func = web3.eth.contract(compiledContract.createOffer.info.abiDefinition);
	var takeOffer_func = web3.eth.contract(compiledContract.takeOffer.info.abiDefinition);
	var refund_func = web3.eth.contract(compiledContract.refund.info.abiDefinition);
	
	var _greeting = "Hello World!"
	var greeterContract = web3.eth.contract(greeterCompiled.greeter.info.abiDefinition);

	var createOffer_exec = createOffer_func.new(uint T, uint minThreshold, uint maxThreshold, uint amount,{from:web3.eth.accounts[0], data: compiledContract.createOffer.code, gas: 300000}, function(e, contract){
    if(!e) {

      if(!contract.address) {
        console.log("Contract transaction send: TransactionHash: " + contract.transactionHash + " waiting to be mined...");

      } else {
        console.log("Contract mined! Address: " + contract.address);
        console.log(contract);
      }

    }
})




    $("#onclickHedger").click(function() {
        $("#contactdiv").css("display", "block");
    });
    $("#contact #cancel").click(function() {
        $(this).parent().parent().hide();
    });
    // Contact form popup send-button click event.
    $("#send").click(function() {
        var name = $("#name").val();
        var email = $("#email").val();
        var contact = $("#contactno").val();
        var message = $("#message").val();
        if (name == "" || email == "" || contactno == "" || message == "") {
            alert("Please Fill All Fields");
        } else {
            if (validateEmail(email)) {
                $("#contactdiv").css("display", "none");
            } else {
                alert('Invalid Email Address');
            }

            function validateEmail(email) {
                var filter = /^[\w\-\.\+]+\@[a-zA-Z0-9\.\-]+\.[a-zA-z0-9]{2,4}$/;
                if (filter.test(email)) {
                    return true;
                } else {
                    return false;
                }
            }
        }
    });
});