const fs = require('fs');
const path = require('path');
const { exec } = require('child_process');


module.exports = function (plop) {

    // ...
    plop.setActionType('exec', function (answers, config, plop) {
        return new Promise((resolve, reject) => {
        exec(config.command, (error, stdout, stderr) => {
            if (error) {
            console.error(`Errore: ${error.message}`);
            reject(error);
            }
            if (stderr) {
            console.error(`Stderr: ${stderr}`);
            reject(new Error(stderr));
            }
            console.log(`Result: ${stdout}`);
            resolve(stdout);
        });
        });
    });

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
                    path: 'output/nginx.conf',
                    templateFile: 'plop-templates/nginx-config.hbs',
                    data: { servers: jsonData }, // Pass all server data to the template
                },
                {
                    type: 'add',
                    path: 'output/config',
                    templateFile: 'plop-templates/ssh-config.hbs',
                    data: { servers: jsonData }, // Pass all server data to the template
                },
                {
                    type: 'exec',
                    command: `bash gen_deploy_keys.sh ${answers.jsonPath}`,  // The script to run (replace {{scriptName}} with input value)
                    message: 'Executing script to generate deploy keys...',
                  }
            ];
        },
    });
};
