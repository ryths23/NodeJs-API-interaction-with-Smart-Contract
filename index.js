const ethers=require('ethers');
require('dotenv').config();
const INFURA_API_KEY=process.env.INFURA_API_KEY;
const API_URL=process.env.API_URL;
const SEPOLIA_PRIVATE_KEY=process.env.SEPOLIA_PRIVATE_KEY;
const CONTRACT_ADDRESS=process.env.CONTRACT_ADDRESS;

const provider=new ethers.providers.JsonRpcProvider(API_URL);
const signer=new ethers.Wallet(SEPOLIA_PRIVATE_KEY,provider);
const {abi}=require("./artifacts/contracts/todoList.sol/todoList.json");

const contractinsstance=new ethers.Contract(CONTRACT_ADDRESS,abi,signer);

const express=require('express');
const app=express();
app.use(express.json());

app.get('/tasks/readAll', async(req,res)=>{
    try{
        const task=await contractinsstance.readAllTask();
        res.send(task);
    }catch(error){
        res.status(500).send(error.message);
    }
})
app.get('/tasks/read/:id', async(req,res)=>{
    try{
        const id=req.params.id;
        const task=await contractinsstance.readTask(id);
        res.send(task);
    }catch(error){
        res.status(500).send(error.message);
    }
})

app.post('/tasks/create', async(req,res)=>{
    try{
        const {authorName,description,deadline,reward}=req.body;
        const task=await contractinsstance.createTask(authorName,description,deadline,reward);
        // const {name,title,condition,reward}=req.body;
        // const task=await contractinsstance.createTask(name,title,condition,reward);
        await task.wait();
        res.send({success:true});
    }catch(error){
        res.status(500).send(error.message);
    }
})

app.put('/tasks/update/:id',async(req,res)=>{
    try{
        const id=req.params.id;
        const {authorName,description,deadline,reward}=req.body;
        const task=await contractinsstance.updateTask(id,authorName,description,deadline,reward);
        // const {name,title,condition,reward}=req.body;
        // const task=await contractinsstance.updateTask(id,name,title,condition,reward);
        await task.wait();
        res.send({success:true});
    }catch(error){
        res.status(500).send(error.message);

    }
})
app.delete('/tasks/delete/:id',async(req,res)=>{
    try{
        const id=req.params.id;
        const task=await contractinsstance.deleteTask(id);
        await task.wait();
        res.send({success:true});
    }catch(error){
        res.status(500).send(error.message);
    }
})
const port = 3000;
app.listen(port, () => {
    console.log("API server is listening on port 3000")
})
