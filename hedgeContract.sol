import "lib/std.sol";
import "lib/oraclizeAPI.sol";

contract HedgerContract is usingOraclize {
	event Print(string str);
	address owner;
	
	function uintToBytes(uint v) constant returns (bytes32 ret) {
		if (v == 0) {
			ret = '0';
		}
		else {
			while (v > 0) {
				ret = bytes32(uint(ret) / (2 ** 8));
				ret |= bytes32(((v % 10) + 48) * 2 ** (8 * 31));
				v /= 10;
			}
		}
		return ret;
	}
	
	function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
	
		uint minLength = length + toOffset;
	
		if (to.length < minLength) {
			// Buffer too small
			throw; // Should be a better way?
		}
	
		// NOTE: the offset 32 is added to skip the `size` field of both bytes variables
		uint i = 32 + fromOffset;
		uint j = 32 + toOffset;
	
		while (i < (32 + fromOffset + length)) {
			assembly {
				let tmp := mload(add(from, i))
				mstore(add(to, j), tmp)
			}
			
			i += 32;
			j += 32;
		}
		return to;
	}
	
	function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
	    bytes memory _ba = bytes(_a);
	    bytes memory _bb = bytes(_b);
	    bytes memory _bc = bytes(_c);
	    bytes memory _bd = bytes(_d);
	    bytes memory _be = bytes(_e);
	    string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
	    bytes memory babcde = bytes(abcde);
	    uint k = 0;
	    for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
	    for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
	    for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
	    for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
	    for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
	    return string(babcde);
	}
	
	function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
	    return strConcat(_a, _b, _c, _d, "");
	}
	
	function strConcat(string _a, string _b, string _c) internal returns (string) {
	    return strConcat(_a, _b, _c, "", "");
	}
	
	function strConcat(string _a, string _b) internal returns (string) {
	    return strConcat(_a, _b, "", "", "");
	}
	
	function min(uint a, uint b) returns (uint) {
	    if (a < b) return a;
	    else return b;
	}
	
	function bytes32ToString (bytes32 data) returns (string) {
	    bytes memory bytesString = new bytes(32);
	    for (uint j=0; j<32; j++) {
	        byte char = byte(bytes32(uint(data) * 2 ** (8 * j)));
	        if (char != 0) {
	            bytesString[j] = char;
	        }
	    }
	    return string(bytesString);
	}
	          
	function HedgerContract() {
		owner = msg.sender;
		oraclize_setNetwork(networkID_consensys);
		oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
		update();
	}
	          
	function __callback(bytes32 myid, string result, bytes proof) {
		if (msg.sender != oraclize_cbAddress()) throw;
		
		//USDETH = parseInt(result,6);
		
	}
	      
	function update() {
		/*
        bytes memory to = new bytes(10);
        bytes memory from_bytes = bytes(bytes32ToString(uintToBytes(timestamp)));
    
        oraclize_query("URL", strConcat("json(https://www.cryptocompare.com/api/data/pricehistorical?fsym=ETH&tsyms=USD&ts=", string(copyBytes(from_bytes, 0, 10, to, 0)), ").Data.0.Price"));
        */
	}
	
	function getPrice(uint timestamp) returns (uint) {
		/*
        bytes memory to = new bytes(10);
        bytes memory from_bytes = bytes(bytes32ToString(uintToBytes(timestamp)));
    
        bytes32 result = oraclize_query("URL", strConcat("json(https://www.cryptocompare.com/api/data/pricehistorical?fsym=ETH&tsyms=USD&ts=", string(copyBytes(from_bytes, 0, 10, to, 0)), ").Data.0.Price"));

        
        uint res = parseInt(bytes32ToString(result), 6);
        
        return res;
        */
        
        // FOR DEMO PURPOSES, WE SET THE PRICE SO WE HAVE A LARGE ENOUGH FLUCTUATION
        if (timestamp == block.timestamp) {
        	return 10500;
        } else {
        	return 11000;
        }
        
        

        //Print(bytes32ToString(uintToBytes(res)));
	}
	
	// multiplicity index: 1000 (pips)
	
	struct Offer {
		//string name;
		uint maturity;
		uint startingPrice;
		uint thresholdMIN;
		uint thresholdMAX;
		uint hedgerAmount;
		address speculator;
		uint speculatorAmount;
		uint blockTimestamp; // time at which the speculator accepts the contract <!>
		uint endingPrice;
	}
	
	// address => Offer
	mapping(address => Offer) offerers;
	        
	// Commands
	function createOffer(uint T, uint minThreshold, uint maxThreshold) { // TODO: replace amount by msg.value
			
		if (msg.value >= 10**18 && minThreshold > 0 && minThreshold <= 1000 && maxThreshold >= 1000 && maxThreshold < 10**7) { // check amount is enough [ ], for eliminating poors and precision concerns
			// check parameters are consistent [ ]
			
			// once done, add we create newOffer and add [address, newOffer] to the offerers mapping
			//Myevent(getPriceAtomic());
			offerers[msg.sender] = Offer(T, getPrice(block.timestamp), minThreshold, maxThreshold, msg.value, 0x0, 0, 0, 0); // make args dynamic
		}
	}
	        
	function takeOffer(address hedger) { // ...
		// check amount is enough [ ]
		uint w = offerers[hedger].hedgerAmount;
		uint thresholdMIN = offerers[hedger].thresholdMIN;
		
		if (w/thresholdMIN - w/1000 <= msg.value/1000) { // TODO: how to compute gas price?? Add maxgas?
			// check parameters are consistent [ ]

			offerers[hedger].speculator = msg.sender;
			offerers[hedger].speculatorAmount = msg.value; // how to get money from him?
			offerers[hedger].blockTimestamp = block.timestamp; // how to get money from him?
		}
		//...
	}
	        
	function refund(address hedger) {
		// once the hedge has reached maturity, each participant can call this function to recover their funds
		// FUTURE FUNCTIONALITY: if some funds are not locked, the hedger can retrieve the non-locked funds (so we need two variables: locked_funds and nonlocked_funds)
		if (endTimestamp <= block.timestamp) { // maturity has been reached
			uint endTimestamp = offerers[hedger].blockTimestamp + offerers[hedger].maturity;
			
			if (offerers[hedger].endingPrice == 0)
				offerers[hedger].endingPrice = getPrice(endTimestamp);
			
			uint w = offerers[hedger].hedgerAmount; // hedger amount
			uint ws = offerers[hedger].speculatorAmount; // speculator amount
			uint thresholdMAX = offerers[hedger].thresholdMAX;
			uint thresholdMIN = offerers[hedger].thresholdMIN;
	
			uint P0 = offerers[hedger].startingPrice;
			uint PT = offerers[hedger].endingPrice;
			
			uint hedger_lockedFunds;
			uint hedger_unlockedFunds;
			uint speculator_lockedFunds;
			uint speculator_unlockedFunds;
			
			if (offerers[hedger].speculator == 0x0) { // if offer not taken yet, then destroy and refund
				// refund
				// destroy offer
			}

			if (PT >= P0) { //w  w) { // PT >= P0
					hedger_lockedFunds = 0;
					hedger_unlockedFunds = w - min(w - w * P0 / PT, w - 1000 * w / thresholdMAX);
					speculator_lockedFunds = 0;
					speculator_unlockedFunds = ws + min(w - w * P0 / PT, w - 1000 * w / thresholdMAX);
			} else { // PT < P0
					hedger_lockedFunds = 0;
					hedger_unlockedFunds = w + min(w * P0 / PT - w, 1000 * w / thresholdMIN - w);
					speculator_lockedFunds = 0;
					speculator_unlockedFunds = ws - min(w * P0 / PT - w, 1000 * w / thresholdMIN - w); 
			}
			if (msg.sender == hedger) {
				if (hedger_unlockedFunds > 0) {
					if (hedger.send(hedger_unlockedFunds))
						Print("Money Transfered");
					else
						Print("Transfer Failed");
				}
			}
			if (msg.sender == offerers[hedger].speculator) {
				if (speculator_unlockedFunds > 0) {
					if (offerers[hedger].speculator.send(speculator_unlockedFunds))
						Print("Money Transfered");
					else
						Print("Transfer Failed");
				}
			}
		} else { // maturity has not yet been reached
			hedger_lockedFunds = w - 1000 * w / thresholdMAX;
			hedger_unlockedFunds = 1000 * w / thresholdMAX;
			speculator_lockedFunds = 1000 * w / thresholdMAX - w;
			speculator_unlockedFunds = ws - 1000 * w / thresholdMAX - w; // TODO: make sure it is non-zero.
		}
	}
}