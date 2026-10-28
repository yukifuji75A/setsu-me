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
        lp: {
          bg: '#f7f6fc',
          ink: '#1c1a2e',
          body: '#4a4864',
          sub: '#5c5a73',
          line: '#e3def5',
          'line-2': '#d9d3f0',
          'dark-card': '#171623',
          'dark-muted': '#c4c7da',
          'dark-muted-2': '#a9a6c4',
        },
      },
      backgroundImage: {
        'lp-grid': 'linear-gradient(to right, rgba(124, 90, 240, 0.06) 1px, transparent 1px), linear-gradient(to bottom, rgba(124, 90, 240, 0.06) 1px, transparent 1px)',
      },
      backgroundSize: {
        'lp-grid-size': '40px 40px',
      },
      fontFamily: {
        'zen-kaku': ['"Zen Kaku Gothic New"', 'sans-serif'],
        'plex-mono': ['"IBM Plex Mono"', 'monospace'],
      },
    },
  },
  plugins: [],
}
