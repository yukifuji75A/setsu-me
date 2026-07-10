module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/components/**/*.rb',
  ],
  theme: {
    extend: {
      colors: {
        dark: {
          bg: '#1e2030',
          card: '#272a3d',
          border: '#5b4af0',
          muted: '#8b8fa8',
        },
        accent: {
          purple: '#7c5af0',
          pink: '#e91e8c',
        },
      },
    },
  },
  plugins: [],
}
