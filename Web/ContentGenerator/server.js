const express = require('express');
const bodyParser = require('body-parser');
const yaml = require('yaml');
const fs = require('fs');

const app = express();
const port = 3000;

app.use(bodyParser.json());
app.use(express.static('public'));

app.post('/api/generate-yml', (req, res) => {
    const ymlData = req.body;
    const ymlString = yaml.stringify(ymlData);

    fs.writeFile('output.yml', ymlString, (err) => {
        if (err) {
            return res.status(500).send('Error generating YML file');
        }
        res.send('YML file generated successfully');
    });
});

app.listen(port, () => {
    console.log(`Server running on http://localhost:${port}`);
});

