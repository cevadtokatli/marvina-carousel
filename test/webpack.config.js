module.exports = {
    module: {
        rules: [
            {
                test: /\.coffee$/,
                use: [
                    {
                        loader: 'coffee-loader',
                        options: { 
                            transpile: {
                                presets: ['env'],
                            }
                        }
                    }
                ]
            }
        ]
    },
    resolve: {
        extensions: [ '.coffee', '.js', '.json']
    },
    performance: { 
        hints: false 
    },
    mode: 'none'
}