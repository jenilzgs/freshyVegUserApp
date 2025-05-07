importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-messaging.js");

firebase.initializeApp({
    apiKey: "AIzaSyBCtDfdfPqxXDO6rDNlmQC1VJSHOtuyo3w",
    authDomain: "gem-b5006.firebaseapp.com",
    projectId: "gem-b5006",
    storageBucket: "gem-b5006.firebasestorage.app",
    messagingSenderId: "384321080318",
    appId: "1:384321080318:web:65a2e979404705cc2c0eaf",
});

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((message) => {
  console.log("onBackgroundMessage", message);
});