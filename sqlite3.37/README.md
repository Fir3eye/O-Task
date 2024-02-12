# SQLite 3.35 Installation Guide

## Introduction

This guide provides step-by-step instructions for installing SQLite 3.35 on Ubuntu.

## Prerequisites

Ensure that your system has the necessary prerequisites installed:

- **C Compiler and Build Tools:**
```
  sudo apt update
  sudo apt install build-essential
```


## Step 1: Download SQLite Source Code
```
wget https://www.sqlite.org/2021/sqlite-autoconf-3350000.tar.gz
tar xvf sqlite-autoconf-3350000.tar.gz
cd sqlite-autoconf-3350000
```
## Step 2: Configure and Build SQLite
```
./configure
make
```
## Step 3: Install SQLite
```
sudo make install
```
## Step 4: Verify Installation

```
sqlite3 --version
sudo apt install build-essential
```
