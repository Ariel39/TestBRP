const path = require('path');
import Fastify from 'fastify'
const fs = require('fs');
const MAX_DIRECTORY_SIZE = 10 * 1024 * 1024 * 1024; // 10GB in bytes
const UPLOAD_DIR = path.join(__dirname, 'public/uploads');
let currentDirSize = 0;

import { RekognitionClient, DetectModerationLabelsCommand } from "@aws-sdk/client-rekognition";

const client = new RekognitionClient({ 
    region: "eu-west-2",
    credentials: {
        accessKeyId: process.env.AWS_ACCESS_KEY_ID,
        secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY,
    }
});
const detectNudity = async (imageBytes) => {
  const params = {
    Image: {
      Bytes: imageBytes,
    },
    MinConfidence: 60,
  };

  try {
    const command = new DetectModerationLabelsCommand(params);
    const response = await client.send(command);
    return response.ModerationLabels;
  } catch (err) {
    console.error("Error detecting moderation labels:", err);
    throw err;
  }
};

const fastify = Fastify({
    logger: {
        level: 'error',
    },
    bodyLimit: 1048576 * 2
})

fastify.setErrorHandler((error, request, reply) => {
    console.error('Error caught:', error);

    reply.status(error.statusCode || 500).send({
        success: false,
        message: 'An unexpected error occurred.',
        error: error.message,
    });
});

process.on('uncaughtException', (error) => {
    console.error('Uncaught Exception:', error);
});

process.on('unhandledRejection', (reason, promise) => {
    console.error('Unhandled Rejection at:', promise, 'reason:', reason);
});

fastify.register(require('@fastify/static'), {
    root: path.join(__dirname, 'public'),
    prefix: '/public/', // optional: default '/'
})

fastify.register(require('@fastify/formbody'))
fastify.register(require('fastify-user-agent'))

//
async function calculateDirectorySize(directory) {
    const files = await fs.promises.readdir(directory);

    const promises = files.map(file => {
        const d = path.join(directory, file.toString());        
        return fs.promises.stat(d.toString());
    })

    const stats = await Promise.all(promises);
    const totalSize = stats.reduce((acc, stat) => acc + (stat.isFile() ? stat.size : 0), 0);
    return totalSize;
}

function isJPEG(buffer) {
    return buffer.length > 3 && buffer[0] === 255 && buffer[1] === 216 && buffer[2] === 255;
}

calculateDirectorySize(UPLOAD_DIR).then(size => currentDirSize = size);

const asyncSome = async (arr, predicate) => {
    for (let e of arr) {
        if (await predicate(e)) return true;
    }
    return false;
};

const dontDelete = {
    "2189059952_0.jpg": true,
    "558669269_0.jpg": true,
    "2051571912_0.jpg": true,
    "2847364262_0.jpg": true,
    "521609087_0.jpg": true,
    "3431138760_0.jpg": true,
    "2535473356_0.jpg": true,
    "2334774600_0.jpg": true,
    "345797620_0.jpg": true,
    "1922447093_0.jpg": true,
    "3934069807_0.jpg": true,
    "1120643971_0.jpg": true,
    "1970603730_0.jpg": true,
    "629892907_0.jpg": true,
    "3568149653_0.jpg": true,
    "2398548153_0.jpg": true,
    "3180177695_0.jpg": true,
    "13029786_0.jpg": true,
    "112759026_0.jpg": true,
    "2347496489_0.jpg": true,
    "1425880340_0.jpg": true,
    "1630237813_0.jpg": true,
    "1779062337_0.jpg": true,
    "3208798107_0.jpg": true,
    "103494872_0.jpg": true,
    "3575336998_0.jpg": true,
    "2031705833_0.jpg": true
}

fastify.post('/upload_picture', async function handler (req, reply) {
    let picture = req.body.img;
    const buffer = Buffer.from(picture, 'base64');

    if (!isJPEG(buffer)) 
        return "[APhone] Error - Not a picture";

    currentDirSize += buffer.length;

    if(currentDirSize > MAX_DIRECTORY_SIZE){
        // Delete 50 old pictures
        const files = await fs.promises.readdir(UPLOAD_DIR);
        const fileStats = await Promise.all(files.map(async (file) => {
            const filePath = fs.join(UPLOAD_DIR, file);
            const stats = await fs.promises.stat(filePath);

            if (dontDelete[file] !== undefined) {
                return { filePath, mtime: new Date() };
            } else {
                return { filePath, mtime: stats.mtime };
            }
        }));

        const sortedFiles = fileStats.sort((a, b) => a.mtime - b.mtime);

        const filesToDelete = sortedFiles.slice(0, 50);
        await Promise.all(filesToDelete.map(file => unlink(file.filePath)));
        currentDirSize = await calculateDirectorySize(UPLOAD_DIR);
    }

    const sha = Bun.hash.crc32(buffer);

    const files = (await fs.promises.readdir(UPLOAD_DIR)).filter(fn => fn.startsWith(sha));
    let fileName;

    await asyncSome(files, async (value) => {
        const f = Bun.file(UPLOAD_DIR + "/" + value);
        const fileText = await f.text();

        if (fileText === buffer.toString())
            fileName = value;

        return fileText === buffer;
    });

    if (fileName)
        return fileName.replace('.jpg', '');

    // Upload
    const moderationLabels = await detectNudity(buffer);
  
    if (moderationLabels && moderationLabels.length > 0)
        return "[APhone] Error - Invalid picture"

    fileName = sha + "_" + (files.length + "");
    Bun.write(UPLOAD_DIR + "/" + fileName + ".jpg", buffer);
    return fileName.replace('.jpg', '');
})

try {
    await fastify.listen( {port: 8000, host: '0.0.0.0'})
} catch (err) {
    fastify.log.error(err)
    process.exit(1)
}

console.log("Loaded and ready");