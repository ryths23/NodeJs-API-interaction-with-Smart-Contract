// SPDX-License-Identifier: SEE LICENSE IN LICENSE

pragma solidity ^0.8.9;
contract todolist{
    uint256 public count = 0;
    struct Task{
        string name;
        string title;
        string conditions;
        uint256 reward;
        address author;
    }
    address owner;
    constructor(){
        owner=msg.sender;
    }

    mapping (uint256=>bool) public taskPresent;
    mapping (uint256=>Task) public taskList;

    event Action(uint256 taskID,string actionType);
    modifier onlyOwner {
        require(msg.sender==owner);
        _;
    }
    function createTask(string memory name, string memory title,string memory condition, uint256 reward) public onlyOwner {
        require(bytes(name).length>0,"Name of the user cannot be empty");
        require(bytes(title).length>0,"Task cannot be empty");
        require(bytes(condition).length>0,"Task condition cannot be empty");
        Task memory newTask=Task(name,title,condition,reward,owner);
        taskList[count]=newTask;
        taskPresent[count]=true;
        count++;
        emit Action(count,"Task Created");
    }

    function readTask(uint256 taskID) external view returns (Task memory){
        require(taskPresent[taskID],"Invalid taskID");
        return taskList[taskID];
    }

    function updateTask(uint256 taskID,string memory name, string memory title,string memory condition, uint256 reward) public onlyOwner{
        require(taskPresent[taskID],"invalid taskId");
        require(taskList[taskID].author==owner,"Unauthorized Identity, cannot update the task");
        taskList[taskID]=Task(name,title,condition,reward,owner);
        emit Action(taskID,"Task Updated");

    }
    function deleteTask(uint256 taskID) public onlyOwner{
        require(taskList[taskID].author==owner,"Unauthorized Identity, cannot delete the task");
        taskPresent[taskID]=false;
        delete taskList[taskID];
        emit Action(taskID,"Task Deleted");
    }
}