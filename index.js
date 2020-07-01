const functions = require('firebase-functions');

const admin = require('firebase-admin')
admin.initializeApp();

const db = admin.firestore();

const fcm = admin.messaging();

exports.sendNewWallpaperNotification = functions.firestore.document("Wallpapers/{wallpaperId}").onCreate(snapshot => {
    const data = snapshot.data();
    var payload = {
      notification: {
          title: "Backdrop",
          body: "New wallpaper",
          
          image: "https://images.unsplash.com/photo-1530908295418-a12e326966ba?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80",

        
          

      }, 
     //icon: "https://drive.google.com/file//1MVXZhIk6XRNNbPXwuvLemPxRQ_xF-Z7I/view?usp=sharing" ,
    };

    const topic = "promotion";

    return fcm.sendToTopic(topic,payload);





})
