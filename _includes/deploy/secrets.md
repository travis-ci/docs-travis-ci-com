{% unless page.provider == 'script' %}
## Securing secrets

Secret option values should be given as either encrypted strings in your build
configuration (`.travis.yml` file) or environment variables in your repository
settings.

Environment variables can be set on the settings page of your repository, or
using `travis env set`:

```bash
travis env set {{include.env_name}} <{{include.name}}>
```

In order to encrypt option values when adding them to your `.travis.yml` file
use `travis encrypt`:

```bash
travis encrypt <{{include.name}}>
```

Or use `--add` to directly add it to your `.travis.yml` file. Note that this command has to be run in your repository's root directory:

```bash
travis encrypt --add deploy.{{include.name}} <{{include.name}}>
```

{% endunless %}
