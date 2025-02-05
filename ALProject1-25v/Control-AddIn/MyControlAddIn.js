var getClientIP = function () {

    fetch('https://api.ipify.org?format=json').then(response => response.json()) .then(data => {
            var ip = data.ip;  // Public IP from the API
            // Send the IP back to AL
            if (window.parent && window.parent.ALSimpleSubscriber) {
                window.parent.ALSimpleSubscriber.sendMessage("clientIp", ip);
            }
        }).catch(err => console.error('Error fetching IP:', err));

};

// Call the function to get the IP address

