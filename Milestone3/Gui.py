from flask import Flask, render_template
import matplotlib.pyplot as plt
from io import BytesIO
import base64
import numpy as np
import os

app = Flask(__name__)

@app.route('/')
def plot():
    # Create a larger figure and axis
    fig, ax = plt.subplots(figsize=(15, 7))
    fig.patch.set_facecolor('#4e4e50')
    
    # Set axis limits
    ax.set_xlim(0, 8)
    ax.set_ylim(0, 5)
    
    # Add x and y axis lines
    ax.axhline(0, color='black', linewidth=1)
    ax.axvline(0, color='black', linewidth=1)
    
    for i in range(8):
        ax.axhline(i, color='#A9A9A9', linewidth=1)
        ax.axvline(i, color='#A9A9A9', linewidth=1)
    
    # Add a dot to the middle of the plot
    # Read data from CSV file
    middle_y, middle_x = np.loadtxt('estimated_position.csv', delimiter=',', unpack=True)

    middle_y = middle_y*10  # Middle x-coordinate
    middle_x = middle_x*10  # Middle y-coordinate
    ax.plot(middle_x, middle_y, 'x', markersize=10)
    
    ax.set_title("EEE3097S TDOA PROJECT Grid")
    ax.set_xlabel('X-Axis')
    ax.set_ylabel('Y-Axis')
    
    # Save the plot to a BytesIO object
    img = BytesIO()
    plt.savefig(img, format='png')
    img.seek(0)
    
    # Encode the plot as a base64 string
    plot_url = base64.b64encode(img.getvalue()).decode()
    
    # Close the figure to release resources
    plt.close(fig)
    
    # Render the template with the plot image
    return render_template('index.html', plot_url=plot_url)

@app.route('/start')
def start():
    os.system("python AcoProject.py Audio")
    #plot()
        # Create a larger figure and axis
    fig, ax = plt.subplots(figsize=(15, 7))
    fig.patch.set_facecolor('#4e4e50')
    
    # Set axis limits
    ax.set_xlim(0, 8)
    ax.set_ylim(0, 5)
    
    # Add x and y axis lines
    ax.axhline(0, color='black', linewidth=1)
    ax.axvline(0, color='black', linewidth=1)
    
    for i in range(8):
        ax.axhline(i, color='#A9A9A9', linewidth=1)
        ax.axvline(i, color='#A9A9A9', linewidth=1)
    
    # Add a dot to the middle of the plot
    # Read data from CSV file
    middle_x, middle_y = np.loadtxt('estimated_position.csv', delimiter=',', unpack=True)

    middle_x = middle_x/100  # Middle x-coordinate
    middle_y = middle_y/100  # Middle y-coordinate
    ax.plot(middle_x, middle_y, 'x', markersize=10)
    
    ax.set_title("EEE3097S TDOA PROJECT Grid")
    ax.set_xlabel('X-Axis')
    ax.set_ylabel('Y-Axis')
    
    # Save the plot to a BytesIO object
    img = BytesIO()
    plt.savefig(img, format='png')
    img.seek(0)
    
    # Encode the plot as a base64 string
    plot_url = base64.b64encode(img.getvalue()).decode()
    
    # Close the figure to release resources
    plt.close(fig)
    
    # Render the template with the plot image
    return render_template('index.html', plot_url=plot_url)

@app.route('/pause')
def pause():
    os.system("^C")

    fig, ax = plt.subplots(figsize=(15, 7))
    fig.patch.set_facecolor('#4e4e50')
    
    # Set axis limits
    ax.set_xlim(0, 8)
    ax.set_ylim(0, 5)
    
    # Add x and y axis lines
    ax.axhline(0, color='black', linewidth=1)
    ax.axvline(0, color='black', linewidth=1)
    
    for i in range(8):
        ax.axhline(i, color='#A9A9A9', linewidth=1)
        ax.axvline(i, color='#A9A9A9', linewidth=1)
    
    # Add a dot to the middle of the plot
    # Read data from CSV file
    middle_x, middle_y = np.loadtxt('estimated_position.csv', delimiter=',', unpack=True)

    middle_x = middle_x/100  # Middle x-coordinate
    middle_y = middle_y/100  # Middle y-coordinate
    ax.plot(middle_x, middle_y, 'x', markersize=10)
    
    ax.set_title("EEE3097S TDOA PROJECT Grid")
    ax.set_xlabel('X-Axis')
    ax.set_ylabel('Y-Axis')
    
    # Save the plot to a BytesIO object
    img = BytesIO()
    plt.savefig(img, format='png')
    img.seek(0)
    
    # Encode the plot as a base64 string
    plot_url = base64.b64encode(img.getvalue()).decode()
    
    # Close the figure to release resources
    plt.close(fig)
    
    # Render the template with the plot image
    return render_template('index.html', plot_url=plot_url)
    return ""

if __name__ == '__main__':
    app.run(debug=True)
