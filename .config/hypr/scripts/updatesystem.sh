#!/bin/bash

echo "Updating system..."
sudo pacman -Syu

echo "Cleaning up unnecessary packages..."
sudo pacman -Qdtq | sudo pacman -Rns -

echo "Cleaning package cache..."
sudo pacman -Sc

echo "System updated successfully!"