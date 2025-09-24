// constructor-args.js
require('dotenv').config();

const constructorArgs = [
  process.env.OWNER_ADDRESS,
  [process.env.OWNER_ADDRESS, process.env.OWNER_ADDRESS2],
  2
];

module.exports = constructorArgs;