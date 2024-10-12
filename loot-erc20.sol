// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LotteryToken {
    string public name = "LotteryToken";
    string public symbol = "LTK";
    uint8 public decimals = 18;
    uint256 public totalSupply;
    uint256 public maxSupply = 10000 * 10 ** uint256(decimals);

    mapping(address => uint256) public balanceOf;

    event Transfer(address indexed from, address indexed to, uint256 value);

    constructor() {
        // Le constructeur peut rester vide ou initialiser des variables si nécessaire
    }

    function mint() external returns (uint256) {
        require(totalSupply < maxSupply, "Max supply reached");

        // Générer un nombre aléatoire entre 1 et 100
        uint256 randomAmount = _getRandomNumber(msg.sender) % 100 + 1;
        uint256 amountToMint = randomAmount * 10 ** uint256(decimals);

        // Vérifier que le mint ne dépasse pas le maxSupply
        if (totalSupply + amountToMint > maxSupply) {
            amountToMint = maxSupply - totalSupply;
        }

        totalSupply += amountToMint;
        balanceOf[msg.sender] += amountToMint;

        emit Transfer(address(0), msg.sender, amountToMint);

        return amountToMint;
    }

    function _getRandomNumber(address sender) internal view returns (uint256) {
        // Attention : Cette méthode de génération aléatoire n'est pas sécurisée
        return uint256(keccak256(abi.encodePacked(block.timestamp, sender, block.difficulty)));
    }

    // Fonctions de transfert standard
    function transfer(address recipient, uint256 amount) external returns (bool) {
        require(balanceOf[msg.sender] >= amount, "Balance insuffisante");
        require(recipient != address(0), "Adresse destinataire invalide");

        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;

        emit Transfer(msg.sender, recipient, amount);
        return true;
    }
}
