// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Pausable.sol";

contract Only42 is ERC20, Ownable, Pausable {
    
    // Maximum supply cap
    uint256 public constant MAX_SUPPLY = 42 * 10**18; // 42 tokens

    // Mining conf
    uint256 public constant MAX_ACTIVE_PROBLEMS = 10;
    uint256 public constant INITIAL_REWARD = 42 * 10**14;
    uint256 public constant HALVE_INTERVAL = 5_000;

    // Mining state
    uint256 public totalMiningReward;
    uint256 public currentReward;
    uint256 public nbProblemsSolved;

    // Multisig configuration
    address[] public multisigOwners;
    uint256 public requiredApprovals;
    uint256 public proposalCount;
    
    // Proposal structure
    struct Proposal {
        string action;          // "pause" or "unpause"
        address proposer;       // Who proposed
        uint256 approvals;      // Number of approvals
        bool executed;          // If already executed
        mapping(address => bool) hasApproved; // Who has approved
    }

    struct Problem {
        uint256 id;
        uint256 firstNumber;
        uint256 secondNumber;
        bool isSolved;
    }
    
    // Mappings
    mapping(uint256 => Proposal) public proposals;
    mapping(address => bool) public isMultisigOwner;
    Problem[] public currentProblems;

    // Events for transparency
    event TokensMinted(address indexed to, uint256 amount);
    event TokensBurned(address indexed from, uint256 amount);
    event ContractPaused(address indexed by);
    event ContractUnpaused(address indexed by);
    event NewProblemGenerated(uint256 indexed problemId, uint256 firstNumber, uint256 secondNumber);
    event ProblemSolved(uint256 indexed problemId, address solver);
    
    // Multisig events
    event ProposalCreated(uint256 indexed proposalId, string action, address indexed proposer);
    event ProposalApproved(uint256 indexed proposalId, address indexed approver);
    event ProposalExecuted(uint256 indexed proposalId, string action);
    
    constructor(address _initialOwner, address[] memory _multisigOwners, uint256 _requiredApprovals) ERC20("Only42", "OFT") Ownable(_initialOwner) {
        require(_multisigOwners.length > 0, "Need at least one multisig owner");
        require(_requiredApprovals > 0 && _requiredApprovals <= _multisigOwners.length, "Invalid required approvals");
        
        currentReward = INITIAL_REWARD;
        totalMiningReward = 0;
        nbProblemsSolved = 0;

        // Set up multisig owners
        for (uint256 i = 0; i < _multisigOwners.length; i++) {
            require(_multisigOwners[i] != address(0), "Invalid owner address");
            require(!isMultisigOwner[_multisigOwners[i]], "Duplicate owner");
            
            multisigOwners.push(_multisigOwners[i]);
            isMultisigOwner[_multisigOwners[i]] = true;
        }

        // Generate initial problems
        for (uint256 i = 0; i < MAX_ACTIVE_PROBLEMS; i++) {
            _generateNewProblem();
        }
        
        requiredApprovals = _requiredApprovals;
        
        uint256 initialSupply = 0;
        _mint(_initialOwner, initialSupply);
        emit TokensMinted(_initialOwner, initialSupply);
    }

    // Multisig modifier
    modifier onlyMultisigOwner() {
        require(isMultisigOwner[msg.sender], "Only42: caller is not a multisig owner");
        _;
    }
    
    // Modifier to check if proposal exists and is not executed
    modifier validProposal(uint256 _proposalId) {
        require(_proposalId < proposalCount, "Proposal does not exist");
        require(!proposals[_proposalId].executed, "Proposal already executed");
        _;
    }
    
    function _generateNewProblem() internal {
        // Generate two random numbers between 1 and 1000
        uint256 firstNumber = uint256(keccak256(abi.encodePacked(block.timestamp, block.prevrandao, currentProblems.length))) % 1000;
        uint256 secondNumber = uint256(keccak256(abi.encodePacked(block.timestamp, block.prevrandao, firstNumber))) % 1000;
        uint256 id = uint256(keccak256(abi.encodePacked(block.timestamp, block.prevrandao, firstNumber, secondNumber)));
        
        // Create new problem
        Problem memory newProblem = Problem({
            id: id,
            firstNumber: firstNumber,
            secondNumber: secondNumber,
            isSolved: false
        });
        
        currentProblems.push(newProblem);
        
        emit NewProblemGenerated(currentProblems.length - 1, firstNumber, secondNumber);
    }

    function mine(uint256 problemId, uint256 answer) public whenNotPaused {
        require(totalSupply() < MAX_SUPPLY, "Maximum supply reached");
        
        // Find the problem with matching ID
        bool found = false;
        uint256 problemIndex;
        for(uint256 i = 0; i < currentProblems.length; i++) {
            if(currentProblems[i].id == problemId) {
                found = true;
                problemIndex = i;
                break;
            }
        }
        require(found, "Problem not found");
        require(!currentProblems[problemIndex].isSolved, "Problem already solved");
        require(answer == currentProblems[problemIndex].firstNumber + currentProblems[problemIndex].secondNumber, "Wrong answer!");
        
        // Mark problem as solved
        currentProblems[problemIndex].isSolved = true;
        nbProblemsSolved++;
        if (nbProblemsSolved % HALVE_INTERVAL == 0) {
            currentReward /= 2;
        }
        // Mint reward
        _mint(msg.sender, currentReward);
        totalMiningReward += currentReward;
        
        emit TokensMinted(msg.sender, currentReward);
        emit ProblemSolved(problemId, msg.sender);
        
        if (problemIndex != currentProblems.length - 1) {
            currentProblems[problemIndex] = currentProblems[currentProblems.length - 1];
        }
        currentProblems.pop();
        _generateNewProblem();
    }

    /**
     * @dev Get all active problems
     */
    function getActiveProblems() public view returns (Problem[] memory) {
        return currentProblems;
    }

    /**
     * @dev Get number of active problems
     */
    function getProblemCount() public view returns (uint256) {
        return currentProblems.length;
    }

    /**
     * @dev Create a proposal to pause the contract
     */
    function proposePause() public onlyMultisigOwner returns (uint256) {
        uint256 proposalId = proposalCount++; // Random ? 
        
        Proposal storage newProposal = proposals[proposalId];
        newProposal.action = "pause";
        newProposal.proposer = msg.sender;
        newProposal.approvals = 1; // Auto-approve from proposer
        newProposal.hasApproved[msg.sender] = true;
        
        emit ProposalCreated(proposalId, "pause", msg.sender);
        emit ProposalApproved(proposalId, msg.sender);
        
        // Check if we can execute immediately
        _checkAndExecuteProposal(proposalId);
        
        return proposalId;
    }
    
    /**
     * @dev Create a proposal to unpause the contract
     */
    function proposeUnpause() public onlyMultisigOwner returns (uint256) {
        uint256 proposalId = proposalCount++;
        
        Proposal storage newProposal = proposals[proposalId];
        newProposal.action = "unpause";
        newProposal.proposer = msg.sender;
        newProposal.approvals = 1; // Auto-approve from proposer
        newProposal.hasApproved[msg.sender] = true;
        
        emit ProposalCreated(proposalId, "unpause", msg.sender);
        emit ProposalApproved(proposalId, msg.sender);
        
        // Check if we can execute immediately
        _checkAndExecuteProposal(proposalId);
        
        return proposalId;
    }
    
    /**
     * @dev Approve a proposal
     */
    function approveProposal(uint256 _proposalId) public onlyMultisigOwner validProposal(_proposalId) {
        Proposal storage proposal = proposals[_proposalId];
        require(!proposal.hasApproved[msg.sender], "Already approved this proposal");
        
        proposal.hasApproved[msg.sender] = true;
        proposal.approvals++;
        
        emit ProposalApproved(_proposalId, msg.sender);
        
        // Check if we can execute now
        _checkAndExecuteProposal(_proposalId);
    }
    
    /**
     * @dev Internal function to check and execute proposal if enough approvals
     */
    function _checkAndExecuteProposal(uint256 _proposalId) internal {
        Proposal storage proposal = proposals[_proposalId];
        
        if (proposal.approvals >= requiredApprovals && !proposal.executed) {
            proposal.executed = true;
            
            if (keccak256(bytes(proposal.action)) == keccak256(bytes("pause"))) {
                _pause();
                emit ContractPaused(address(this));
            } else if (keccak256(bytes(proposal.action)) == keccak256(bytes("unpause"))) {
                _unpause();
                emit ContractUnpaused(address(this));
            }
            
            emit ProposalExecuted(_proposalId, proposal.action);
        }
    }
    
    /**
     * @dev Get proposal details
     */
    function getProposal(uint256 _proposalId) public view returns (
        string memory action,
        address proposer,
        uint256 approvals,
        bool executed
    ) {
        require(_proposalId < proposalCount, "Proposal does not exist");
        Proposal storage proposal = proposals[_proposalId];
        return (proposal.action, proposal.proposer, proposal.approvals, proposal.executed);
    }
    
    /**
     * @dev Check if an address has approved a proposal
     */
    function hasApprovedProposal(uint256 _proposalId, address _owner) public view returns (bool) {
        require(_proposalId < proposalCount, "Proposal does not exist");
        return proposals[_proposalId].hasApproved[_owner];
    }
    
    /**
     * @dev Get multisig owners
     */
    function getMultisigOwners() public view returns (address[] memory) {
        return multisigOwners;
    }
    
    /**
     * @dev Burn tokens from caller's balance
     * @param amount Amount of tokens to burn
     */
    function burn(uint256 amount) public {
        require(balanceOf(msg.sender) >= amount, "Only42: insufficient balance to burn");
        
        _burn(msg.sender, amount);
        emit TokensBurned(msg.sender, amount);
    }
    
    /**
     * @dev Override transfer to include pause functionality
     */
    function transfer(address to, uint256 amount) public virtual override whenNotPaused returns (bool) {
        return super.transfer(to, amount);
    }
    
    /**
     * @dev Override transferFrom to include pause functionality
     */
    function transferFrom(address from, address to, uint256 amount) public virtual override whenNotPaused returns (bool) {
        return super.transferFrom(from, to, amount);
    }
    
    /**
     * @dev Get contract information for documentation
     */
    function getContractInfo() public pure returns (string memory, string memory, uint256, uint8) {
        return ("Only42", "OFT", 42 * 10**18, 18);
    }
}