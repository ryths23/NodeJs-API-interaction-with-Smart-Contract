// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
contract todoList{
    struct Task{
        uint taskID;
        string authorName;
        address authorAddress;
        string description;
        uint deadline;
        Condition[] conditionList;
        uint reward;
        bool isCompleted;
    }
    struct Condition{
        string title;
        uint weightage;
    }
    struct Customer{
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
    mapping(uint=>Customer[]) public customerList;

    modifier onlyOwner {
        require(msg.sender==owner);
        _;
    }
    function createTask(string[] memory title, uint[] memory weightage,string memory authorName, string memory description,uint deadline,uint reward) public onlyOwner{     
        taskPresent[lastIndex]=true;
        Task storage newTask=taskList[lastIndex];
        newTask.authorName=authorName;
        newTask.description=description;
        newTask.deadline=deadline;
        newTask.reward=reward;
        newTask.isCompleted=false;
        for(uint i=0;i<title.length;i++){
            newTask.conditionList.push(Condition(title[i],weightage[i]));
        }
        newTask.authorAddress=owner;
        taskList[lastIndex]=newTask;
        lastIndex++;   
    }
    function readTask(uint taskID) external view returns (Task memory){
        return taskList[taskID];
    }
    function updateTask(uint taskID,string[] memory title, uint[] memory weightage,string memory authorName, string memory description,uint deadline,uint reward) public onlyOwner{
        require(owner==taskList[taskID].authorAddress,"Unauthorized indentity");
        Task storage newTask=taskList[taskID];
        newTask.authorName=authorName;
        newTask.description=description;
        newTask.deadline=deadline;
        newTask.reward=reward;
        newTask.isCompleted=false;
        for(uint i=0;i<title.length;i++){
            newTask.conditionList.push(Condition(title[i],weightage[i]));
        }
        newTask.authorAddress=owner;
        taskList[taskID]=newTask;
    }
    function deleteTask(uint taskID) public onlyOwner{
        require(owner==taskList[taskID].authorAddress,"Unauthorized indentity");
        delete taskPresent[taskID];
        delete taskList[taskID]; 
    }
    function addCustomer(uint taskID,bool[] memory condition) public{
        Customer memory newCustomer=Customer(owner,condition,block.timestamp);
        customerList[taskID].push(newCustomer);
    }
    function getAllCustomers(uint taskID) external view returns(Customer[] memory){
        return customerList[taskID];
    }
    function toggleState(uint taskID) public onlyOwner{
        require(owner==taskList[taskID].authorAddress,"Unauthorized indentity");
        Task storage tempTask=taskList[taskID];
        tempTask.isCompleted=!tempTask.isCompleted;
    }
}