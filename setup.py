from setuptools import setup

setup(name='lavista',
      version='0.0.1',
      packages=['lavista'],
      install_requires=['netifaces', 'pyyaml'],
      maintainer="me",
      maintainer_email="gundy@snakegully.net",
      entry_points={
          'console_scripts': [
              'lavista = lavista.main:cli'
          ]
      },
      )

#
