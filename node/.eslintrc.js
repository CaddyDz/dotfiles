module.exports = {
	root: true,
	env: {
		browser: true,
		node: true
	},
	parserOptions: {
		parser: 'babel-eslint'
	},
	extends: [],
	plugins: [],
	// add your custom rules here
	rules: {
		indent: ['warn', 'tab'],
		'no-tabs': 0,
		'vue/html-closing-bracket-newline': ['error', {
			multiline: 'never'
		}],
		'vue/max-attributes-per-line': 'off',
		'vue/html-indent': ['error', type, {
			attribute: 20,
			baseIndent: 1,
			closeBracket: 1,
			alignAttributesVertically: false,
			ignores: []
		}],
		'vue/html-self-closing': ['error', {
			html: {
				void: 'never',
				normal: 'always',
				component: 'always'
			},
			svg: 'always',
			math: 'always'
		}]
	}
}
