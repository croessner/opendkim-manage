from setuptools import setup

setup(
    name='opendkim-manage',
    version='0.1',
    packages=[''],
    package_dir={'src'},
    url='https://github.com/croessner/opendkim-manage',
    license='GPL2',
    author='Christian Roessner',
    author_email='c@roessner.co',
    description='OpenDKIM management tool for key rollover',
    install_requires=['dns', 'ldap', 'M2Crypto', 'colorama']
)
