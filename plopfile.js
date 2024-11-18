const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');


module.exports = function (plop) {
    plop.setGenerator('nginx-config', {
        description: 'Generate a single Nginx configuration file from JSON input',
        prompts: [
            {
                type: 'input',
                name: 'jsonPath',
                message: 'Enter the path to your JSON file:',
                default: 'input.json',
            },
        ],
        actions: (answers) => {
            const jsonFilePath = path.resolve(answers.jsonPath);

            // Load JSON data
            let jsonData;
            try {
                const rawData = fs.readFileSync(jsonFilePath, 'utf8');
                jsonData = JSON.parse(rawData);
            } catch (err) {
                throw new Error('Could not load or parse the JSON file.');
            }

            return [
                {
                    type: 'add',
                    path: `output/nginx.conf`,
                    templateFile: 'plop-templates/nginx-config.hbs',
                    data: { servers: jsonData }, // Pass all server data to the template
                },
                {
                    type: 'add',
                    path: `output/config`,
                    templateFile: 'plop-templates/ssh-config.hbs',
                    data: { servers: jsonData }, // Pass all server data to the template
                },
            ];
        },
    });
};
