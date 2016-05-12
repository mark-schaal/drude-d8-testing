# Drupal 8 powered by Drude (DrupalCon NOLA 2016)

This is a sample vanila Drupal 8 installation preconfigured for use with Drude. 

## Instructions (Mac, Windows, Linux/Debian-alike)

### Drude environment setup (one-time setup per computer)

1. Copy files from the thumb drive

2. Install babun (Windows only), virtualbox and vagrant.

    Skip components you already have, though upgrading is highly recommended.
    
    IMPORTANT: On Windows all further commands must be run in Babun!

3. Add a preloaded Drude base box (Mac and Windows only)

    ```
    vagrant box add --name drude <path/to/drude.box>
    ```
    
    `<path/to/drude.box>` - file from the thumb drive

4. Install `dsh` (Drude Shell)

    ```
    sudo curl -L https://raw.githubusercontent.com/blinkreaction/drude/master/bin/dsh  -o /usr/local/bin/dsh && \
    sudo chmod +x /usr/local/bin/dsh
    ```

5. Run the following commnads in a folder designated for projects (e.g. ~/projects or c:\projects)

    ```
    B2D_BRANCH=nola dsh install prerequisites && \
    B2D_BRANCH=nola dsh install boot2docker
    ```

6. Make sure the VM can start (Mac and Windows only)

    ```
    vagrant up
    ```
    
    (Windows only - may have to run this 2 times in the very beginning)


## Project setup

1. Clone this repo into the designated folder used previously (e.g. ~/projects or c:\projects)

    ```
    git clone -b nola https://github.com/blinkreaction/drude-d8-testing.git drupal8.drude && \
    cd drupal8.drude
    ```

2. Initialize the site

    This will initialize local settigns and install the site via drush

    ```
    dsh init
    ```

3. Add `192.168.10.10  drupal8.drude` to your hosts file (Windows only)

4. Point your browser to

    ```
    http://drupal8.drude
    ```
