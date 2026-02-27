#!/usr/bin/env node

const sharp = require('sharp');
const path = require('path');
const readline = require('readline');
const fs = require('fs');

const inputFile = process.argv[2];

if (!inputFile) {
    console.error("[X] Please provide an input file.");
    process.exit(1);
}

const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});

const fileName = path.basename(inputFile, path.extname(inputFile));
const dirName = path.dirname(inputFile);

async function processImage() {
    try {
        const image = sharp(inputFile);
        const metadata = await image.metadata();

        if (metadata.hasAlpha) {
            console.log("[!] Transparency detected!");
            rl.question("Do you want a custom background color? (y/N): ", async (answer) => {
                if (answer.toLowerCase() === 'y') {
                    rl.question("[?] Enter color (e.g., #FF0000 or red): ", async (color) => {
                        const safeColor = color.replace(/[^a-zA-Z0-9]/g, '');
                        const outputName = `${fileName}_50x50mm_${safeColor}_bg.jpeg`;
                        await image
                            .resize(591, 591, { fit: 'fill' })
                            .flatten({ background: color })
                            .jpeg({ quality: 95 })
                            .toFile(path.join(dirName, outputName));
                        console.log(`[+] Saved: ${outputName}`);
                        rl.close();
                    });
                } else {
                    await image
                        .resize(591, 591, { fit: 'fill' })
                        .flatten({ background: '#ffffff' })
                        .jpeg({ quality: 95 })
                        .toFile(path.join(dirName, `${fileName}_50x50mm_white_bg.jpeg`));
                    
                    await sharp(inputFile)
                        .resize(591, 591, { fit: 'fill' })
                        .flatten({ background: '#000000' })
                        .jpeg({ quality: 95 })
                        .toFile(path.join(dirName, `${fileName}_50x50mm_black_bg.jpeg`));
                    
                    console.log("[+] Saved White & Black .jpeg versions");
                    rl.close();
                }
            });
        } else {
            const outputName = `${fileName}_50x50mm.jpeg`;
            await image
                .resize(591, 591, { fit: 'fill' })
                .flatten({ background: '#ffffff' })
                .jpeg({ quality: 95 })
                .toFile(path.join(dirName, outputName));
            console.log(`[+] Saved: ${outputName}`);
            process.exit(0);
        }
    } catch (err) {
        console.error("[X] Error processing image:", err.message);
        process.exit(1);
    }
}

processImage();
