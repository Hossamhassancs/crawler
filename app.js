const fs = require('fs');
const path = require('path');

function waitForFile(filePath, interval = 10) {
    return new Promise((resolve, reject) => {
        const intervalId = setInterval(() => {
            if (fs.existsSync(filePath)) {
                clearInterval(intervalId);
                resolve();
            }
        }, interval);
    });
}

function processData(inputFile, outputFile) {
    const data = fs.readFileSync(inputFile, 'utf-8').split('\n').map(line => line.trim()).filter(line => line !== '');
    // Process data as needed
    fs.writeFileSync(outputFile, JSON.stringify(data, null, 2));
    console.log(`Processed data saved to ${outputFile}`);
}

const doneFile = path.resolve(__dirname, 'done.txt');
const csvFile = path.resolve(__dirname, 'example-output-dev-test.csv');
const outputFile = path.resolve(__dirname, 'processed-data.json');

waitForFile(doneFile).then(() => {
    console.log('Ruby script completed, processing data...');
    processData(csvFile, outputFile);
}).catch(err => {
    console.error('Error waiting for file:', err);
});
