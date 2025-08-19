FROM ruby:2.7.8-slim
LABEL maintainer Travis CI GmbH <support+docs-docker-images@travis-ci.com>

# packages required for bundle install
RUN ( \
   apt-get update ; \
   apt-get install -y --no-install-recommends git make gcc g++ libpq-dev libcurl4-openssl-dev curl \
   && rm -rf /var/lib/apt/lists/* \
)

# ------
# Set the encoding to UTF-8
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
# -----
ENV WEBHOOK_PAYLOAD_GIST_ID 4e317d6e71be6d0278be46bb751b2f78

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1
RUN mkdir -p /app

WORKDIR /app
COPY Gemfile      /app
COPY Gemfile.lock /app

RUN gem install bundler:2.4.22
RUN bundler install --verbose --retry=3
RUN gem install --user-install executable-hooks

COPY . /app
RUN bundle exec rake build
COPY . /app

CMD bundle exec puma -p 4000
 
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>3D Space with Socks</title>
  <style>
    body {
      margin: 0;
      overflow: hidden;
    }
  </style>
</head>
<body>
  <script src="https://cdn.jsdelivr.net/npm/three@0.131.2/build/three.min.js"></script>
  <script>
    const scene = new THREE.Scene();
    const camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);
    const renderer = new THREE.WebGLRenderer();
    renderer.setSize(window.innerWidth, window.innerHeight);
    document.body.appendChild(renderer.domElement);

    const geometry = new THREE.BoxGeometry();
    const material = new THREE.MeshBasicMaterial({ color: 0x00ff00 });
    const cube = new THREE.Mesh(geometry, material);
    scene.add(cube);

    camera.position.z = 5;

    const animate = function () {
      requestAnimationFrame(animate);

      cube.rotation.x += 0.01;
      cube.rotation.y += 0.01;

      renderer.render(scene, camera);
    };

    animate();
  </script>
</body>
</html>FROM ruby:2.7.8-slim
LABEL maintainer Travis CI GmbH <support+docs-docker-images@travis-ci.com>

# packages required for bundle install
RUN ( \
   apt-get update ; \
   apt-get install -y --no-install-recommends git make gcc g++ libpq-dev libcurl4-openssl-dev curl \
   && rm -rf /var/lib/apt/lists/* \
)

# ------
# Set the encoding to UTF-8
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
# -----
ENV WEBHOOK_PAYLOAD_GIST_ID 4e317d6e71be6d0278be46bb751b2f78

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1
RUN mkdir -p /app

WORKDIR /app
COPY Gemfile      /app
COPY Gemfile.lock /app

RUN gem install bundler
RUN bundler install --verbose --retry=3
RUN gem install --user-install executable-hooks

COPY . /app
RUN bundle exec rake build
COPY . /app

CMD bundle exec puma -p 4000
 
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>3D Space with Socks</title>
  <style>
    body {
      margin: 0;
      overflow: hidden;
    }
  </style>
</head>
<body>
  <script src="https://cdn.jsdelivr.net/npm/three@0.131.2/build/three.min.js"></script>
  <script>
    const scene = new THREE.Scene();
    const camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);
    const renderer = new THREE.WebGLRenderer();
    renderer.setSize(window.innerWidth, window.innerHeight);
    document.body.appendChild(renderer.domElement);

    const geometry = new THREE.BoxGeometry();
    const material = new THREE.MeshBasicMaterial({ color: 0x00ff00 });
    const cube = new THREE.Mesh(geometry, material);
    scene.add(cube);

    camera.position.z = 5;

    const animate = function () {
      requestAnimationFrame(animate);

      cube.rotation.x += 0.01;
      cube.rotation.y += 0.01;

      renderer.render(scene, camera);
    };

    animate();
  </script>
</body>
</html>