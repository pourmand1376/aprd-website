function appendHTMLContent(url) {
    fetch(url)
        .then(response => {
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            return response.text();
        })
        .then(html => {
            // Create a new div element
            const newContent = document.createElement('div');
            // Set its HTML content
            newContent.innerHTML = html;
            // Append it to the end of the body
            document.body.appendChild(newContent);
        })
        .catch(error => {
            console.error('Error loading HTML content:', error);
        });
}
