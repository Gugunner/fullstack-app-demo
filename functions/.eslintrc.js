module.exports = {
  root: true,
  env: {
    es6: true,
    node: true,
  },
  extends: [
    "eslint:recommended",
    "plugin:import/errors",
    "plugin:import/warnings",
    "plugin:import/typescript",
    "google",
    "plugin:@typescript-eslint/recommended",
  ],
  parser: "@typescript-eslint/parser",
  parserOptions: {
    tsconfigRootDir: __dirname,
    sourceType: "module",
  },
  ignorePatterns: [
    "/lib/**/*", // Ignore built files.
  ],
  plugins: [
    "@typescript-eslint",
    "import",
  ],
  rules: {
    //Change to error
    "quotes": ["off", "double"],
    "import/no-unresolved": 0,
    //Change to error
    "indent": ["off", 4],
    "semi": ["off"],
    "require-jsdoc": ["off"],
    "object-curly-spacing": ["off"],
    "spaced-comment": ["off"],
    //Delete later or check
    "no-trailing-spaces": ["off"],
    "no-prototype-builtins": ["off"],
    "valid-jsdoc": ["off"],
    "padded-blocks": ["off"],
    "brace-style": ["off"],
    "block-spacing": ["off"],
    "no-multi-spaces": ["off"],
    "comma-dangle": ["off"],
    "no-tabs": ["off"],
    "no-mixed-spaces-and-tabs": ["off"],
    "eol-last": ["off"],
    "no-multiple-empty-lines": ["off"],
    "no-var": ["off"],
    "comma-spacing": ["off"],
    "semi-spacing": ["off"],
    //Change to error
    "max-len": [
      "off",
      {
        "code": 500,
      },
    ],
    "@typescript-eslint/no-unused-vars": ["off"],
  },
};
