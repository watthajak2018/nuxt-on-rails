export default function () {
  this.extendBuild((config) => {
    config.module.rules.push({
      test: /\.coffee$/,
      use: 'coffee-loader',
      exclude: /(node_modules)/
    });
  })
}
