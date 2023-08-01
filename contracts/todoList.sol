// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
contract list{
    struct Task{
        uint taskID;
        string authorName;
        address authorAddress;
        string description;
        condition[] conditionList;
        uint deadline;
        uint reward;
        bool isCompleted;
    }
    struct condition{
        string title;
        uint weightage;
    }
    struct customer{
        address cus;
        bool[] condition;
        uint timestamp;
    }
    uint public lastIndex=0;
    address owner;
    
    constructor(){
        owner=msg.sender;
    }
    mapping(uint=>bool) public taskPresent;
    mapping(uint=>Task) public taskList;
    mapping(uint=>customer[]) public customerList;

    modifier onlyOwner {
        require(msg.sender==owner);
        _;
    }
    function createTask(string memory authorName, string memory description,condition[] memory conditionList,uint deadline,uint reward) public onlyOwner{     
        taskPresent[lastIndex]=true;
        Task memory newTask=Task(lastIndex,authorName,owner,description,conditionList,deadline,reward,false);
        taskList[lastIndex]=newTask;
        lastIndex++;   
    }
    function readTask(uint taskID) external view returns (Task memory){
        return taskList[taskID];
    }
    function readAllTask() public  view returns (Task[] memory){
        Task[] memory taskitems;
        for(uint i=0;i<lastIndex;i++){
            taskitems[i]=taskList[i];       
        }
        return taskitems;
    }
    function updateTask(uint taskID,string memory authorName, string memory description,condition[] memory conditionList,uint deadline,uint reward) public onlyOwner{
        require(owner==taskList[taskID].authorAddress,"Unauthorized indentity");
        Task memory newTask=Task(taskID,authorName,owner,description,conditionList,deadline,reward,false);
        taskList[taskID]=newTask;
    }
    function deleteTask(uint taskID) public onlyOwner{
        require(owner==taskList[taskID].authorAddress,"Unauthorized indentity");
        delete taskPresent[taskID];
        delete taskList[taskID]; 
    }
    function addCustomer(uint taskID,bool[] memory condition) public{
        customer memory newCustomer=customer(owner,condition,block.timestamp);
        customerList[taskID].push(newCustomer);
    }
    function getAllCustomers(uint taskID) external view returns(customer[] memory){
        return customerList[taskID];
    }
    function changeState(uint taskID) public onlyOwner{
        require(owner==taskList[taskID].authorAddress,"Unauthorized indentity");
        taskList[taskID].isCompleted=true;
    }
}