importScripts('https://www.gstatic.com/firebasejs/3.9.0/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/3.9.0/firebase-messaging.js');

var config = {
    apiKey: "AIzaSyBtisuPgPCI8Z54LrY9EhiMs1rfEb_mAXA",
    authDomain: "tubes-3-wbd-c0ef6.firebaseapp.com",
    databaseURL: "https://tubes-3-wbd-c0ef6.firebaseio.com",
    projectId: "tubes-3-wbd-c0ef6",
    storageBucket: "tubes-3-wbd-c0ef6.appspot.com",
    messagingSenderId: "585220599787"
};

firebase.initializeApp(config);

const messaging = firebase.messaging();

messaging.setBackgroundMessageHandler(function(payload) {
    console.log('[firebase-messaging-sw.js] Received background message ', payload);
    // Customize notification here
    const notificationTitle = 'Background Message Title';
    const notificationOptions = {
        body: 'Background Message body.',
        icon: '/firebase-logo.png'
    };
    return self.registration.showNotification(notificationTitle,
        notificationOptions);
});