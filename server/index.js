const express = require('express');
const http = require('http');
const { default: mongoose } = require('mongoose');
const { Socket } = require('socket.io');

const app = express();

const port = process.env.PORT || 3000;
var server = http.createServer(app);
var io = require("socket.io")(server);

// middle ware
app.use(express.json());
const Room = require('./models/room');

const DB = "mongodb+srv://onlyprogramming123:hem%40tic-tac-toe@cluster0.fk6td3g.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0";

io.on("connection", (socket) => {
    console.log('connected!');

    socket.on('createRoom', async ({ nickname }) => {
        // console.log(nickname);
        try {
            //room 
            let room = new Room();
            let player = {
                socketID: socket.id,
                nickname,
                playerType: 'X',
            };
            room.players.push(player);
            room.turn = player;
            room = await room.save();

            const roomID = room._id.toString();

            socket.join(roomID);

            io.to(roomID).emit("createRoomSuccess", room);
        } catch (e) {
            console.log(e);
        }
    });



    socket.on('joinRoom', async ({ nickname, roomID }) => {
        try {
            if (!roomID.match(/^[0-9a-fA-F]{24}$/)) {
                socket.emit('errorOccurred', 'Please enter a valid room ID.');
            }

            let room = await Room.findById(roomID);
            if (room.isJoin) {
                let player = {
                    nickname,
                    socketID: socket.id,
                    playerType: 'O',
                };

                socket.join(roomID);
                room.players.push(player);
                room.isJoin = false;
                room = await room.save();

                io.to(roomID).emit("joinRoomSuccess", room);
                io.to(roomID).emit("updatePlayers", room.players);
                io.to(roomID).emit("updateRoom", room);
            } else {
                socket.emit('errorOccurred', 'The game is in progress, try again later');
            }

        } catch (e) {
            console.log(e);
        }
    });


    socket.on('tap', async ({ index, roomID }) => {
        try {
            let room = await Room.findById(roomID);
            let choice = room.turn.playerType;

            if (room.turnIndex == 0) {
                room.turn = room.players[1]
                room.turnIndex = 1
            } else {
                room.turn = room.players[0]
                room.turnIndex = 0
            }

            room = await room.save();
            io.to(roomID).emit('tapped', {
                index,
                choice,
                room,
            });

        } catch (e) {
            console.log(e);
        }
    });


    socket.on('winner', async ({ winnerSocketID, roomID }) => {
        try {
            let room = await Room.findById(roomID);

            let player = room.players.find(
                (player) => player.socketID == winnerSocketID
            )
            
            player.points += 1;
            room = await room.save();

            if (player.points >= room.maxRounds) {
                io.to(roomID).emit('endGame', player);
            } else {
                io.to(roomID).emit('incrementPoint', player);
            }

        } catch (e) {
            console.log(e);
        }

    });
});

mongoose.connect(DB).then(() => {
    console.log("Connection Successful!");
}).catch((e) => {
    console.log(e);
});

server.listen(port, '0.0.0.0', () => {
    console.log(`Server started and running on port ${port}`);
});

