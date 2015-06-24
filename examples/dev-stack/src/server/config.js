var config = {
  isProduction: process.env.NODE_ENV === 'production',
  port: process.env.PORT || 8000,
  version: require('../../package').version
};

module.exports = config;
