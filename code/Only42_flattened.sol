// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

// OpenZeppelin Contracts v4.9.0 (utils/Context.sol)
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

// OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor(address initialOwner) {
        _transferOwnership(initialOwner);
    }

    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// OpenZeppelin Contracts (last updated v4.7.0) (utils/Pausable.sol)
abstract contract Pausable is Context {
    event Paused(address account);
    event Unpaused(address account);

    bool private _paused;

    constructor() {
        _paused = false;
    }

    modifier whenNotPaused() {
        _requireNotPaused();
        _;
    }

    modifier whenPaused() {
        _requirePaused();
        _;
    }

    function paused() public view virtual returns (bool) {
        return _paused;
    }

    function _requireNotPaused() internal view virtual {
        require(!paused(), "Pausable: paused");
    }

    function _requirePaused() internal view virtual {
        require(paused(), "Pausable: not paused");
    }

    function _pause() internal virtual whenNotPaused {
        _paused = true;
        emit Paused(_msgSender());
    }

    function _unpause() internal virtual whenPaused {
        _paused = false;
        emit Unpaused(_msgSender());
    }
}

// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
interface IERC20 {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}

// OpenZeppelin Contracts v4.9.0 (token/ERC20/extensions/IERC20Metadata.sol)
interface IERC20Metadata is IERC20 {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
}

// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/ERC20.sol)
contract ERC20 is Context, IERC20, IERC20Metadata {
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;
    string private _name;
    string private _symbol;

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    function name() public view virtual override returns (string memory) {
        return _name;
    }

    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    function decimals() public view virtual override returns (uint8) {
        return 18;
    }

    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    function transfer(address to, uint256 amount) public virtual override returns (bool) {
        address owner = _msgSender();
        _transfer(owner, to, amount);
        return true;
    }

    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, allowance(owner, spender) + addedValue);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        address owner = _msgSender();
        uint256 currentAllowance = allowance(owner, spender);
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        unchecked {
            _approve(owner, spender, currentAllowance - subtractedValue);
        }
        return true;
    }

    function _transfer(address from, address to, uint256 amount) internal virtual {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(from, to, amount);

        uint256 fromBalance = _balances[from];
        require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked {
            _balances[from] = fromBalance - amount;
            _balances[to] += amount;
        }

        emit Transfer(from, to, amount);
        _afterTokenTransfer(from, to, amount);
    }

    function _mint(address to, uint256 amount) internal virtual {
        require(to != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), to, amount);

        _totalSupply += amount;
        unchecked {
            _balances[to] += amount;
        }
        emit Transfer(address(0), to, amount);

        _afterTokenTransfer(address(0), to, amount);
    }

    function _burn(address from, uint256 amount) internal virtual {
        require(from != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(from, address(0), amount);

        uint256 accountBalance = _balances[from];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked {
            _balances[from] = accountBalance - amount;
            _totalSupply -= amount;
        }

        emit Transfer(from, address(0), amount);
        _afterTokenTransfer(from, address(0), amount);
    }

    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount, "ERC20: insufficient allowance");
            unchecked {
                _approve(owner, spender, currentAllowance - amount);
            }
        }
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
    function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
}

// Your Only42 Contract
contract Only42 is ERC20, Ownable, Pausable {
    
    // Maximum supply cap
    uint256 public constant MAX_SUPPLY = 42 * 10**18; // 42 tokens
    
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
    
    // Mappings
    mapping(uint256 => Proposal) public proposals;
    mapping(address => bool) public isMultisigOwner;

    // Events for transparency
    event TokensMinted(address indexed to, uint256 amount);
    event TokensBurned(address indexed from, uint256 amount);
    event ContractPaused(address indexed by);
    event ContractUnpaused(address indexed by);
    
    // Multisig events
    event ProposalCreated(uint256 indexed proposalId, string action, address indexed proposer);
    event ProposalApproved(uint256 indexed proposalId, address indexed approver);
    event ProposalExecuted(uint256 indexed proposalId, string action);
    
    constructor(address _initialOwner, address[] memory _multisigOwners, uint256 _requiredApprovals) ERC20("Only42", "O42") Ownable(_initialOwner) {
        require(_multisigOwners.length > 0, "Need at least one multisig owner");
        require(_requiredApprovals > 0 && _requiredApprovals <= _multisigOwners.length, "Invalid required approvals");
        
        // Set up multisig owners
        for (uint256 i = 0; i < _multisigOwners.length; i++) {
            require(_multisigOwners[i] != address(0), "Invalid owner address");
            require(!isMultisigOwner[_multisigOwners[i]], "Duplicate owner");
            
            multisigOwners.push(_multisigOwners[i]);
            isMultisigOwner[_multisigOwners[i]] = true;
        }
        
        requiredApprovals = _requiredApprovals;
        
        uint256 initialSupply = MAX_SUPPLY; // Mint the maximum supply at deployment
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
        return ("Only42", "O42", 42 * 10**18, 18);
    }
}