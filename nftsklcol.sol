// SPDX-License-Identifier: MIT LICENSE

 


import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";


pragma solidity ^0.8.4;

contract SkullsCollection is ERC721Enumerable, Ownable {

    
    using Strings for uint256;
    string public baseURI;
    string public baseExtension = ".json";
    uint256 public maxSupply = 2000;
    uint256 public cost = 0.005 ether;
    uint256 public maxMintAmount = 10;
    bool public paused = false;

    constructor() ERC721("BoredSkullsClub", "BCSCOL") {}


    function _baseURI() internal view virtual override returns (string memory) {
    return "ipfs://Qmde6GY5f8xUfzimfFPZ7iSgo2yFeJTQPa2ERwXPSBHe6F/";

    }


    
    function mint(address _to, uint256 _mintAmount) public payable {
            uint256 supply = totalSupply();
            require(!paused);
            require(_mintAmount > 0);
            require(_mintAmount <= maxMintAmount);
            require(supply + _mintAmount <= maxSupply);
            
            if (msg.sender != owner()) {
            require(msg.value == cost * _mintAmount, "Need to send 0.005 ether!");
            }

            for (uint256 i = 1; i <= _mintAmount; i++) {
                _safeMint(_to, supply + i);
            }
    }

    


        function walletOfOwner(address _owner)
        public
        view
        returns (uint256[] memory)
        {
            uint256 ownerTokenCount = balanceOf(_owner);
            uint256[] memory tokenIds = new uint256[](ownerTokenCount);
            for (uint256 i; i < ownerTokenCount; i++) {
                tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
            }
            return tokenIds;
        }
    
        
        function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory) {
            require(
                _exists(tokenId),
                "ERC721Metadata: URI query for nonexistent token"
                );
                
                string memory currentBaseURI = _baseURI();
                return
                bytes(currentBaseURI).length > 0 
                ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
                : "";
        }
        // only owner
        
        function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner() {
            maxMintAmount = _newmaxMintAmount;
        }
        function setListingPrice(uint256 newPrice) public onlyOwner{
            require(newPrice>0,"Price must be at least 1 wei");
            cost=newPrice;
        }
        
        function setBaseURI(string memory _newBaseURI) public onlyOwner() {
            baseURI = _newBaseURI;
        }
        
        function setBaseExtension(string memory _newBaseExtension) public onlyOwner() {
            baseExtension = _newBaseExtension;
        }
        
        function pause(bool _state) public onlyOwner() {
            paused = _state;
        }
        
        function withdraw() public payable onlyOwner() {
            require(payable(msg.sender).send(address(this).balance));
        }
}
