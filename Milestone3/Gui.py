from flask import Flask, render_template
import matplotlib.pyplot as plt
from io import BytesIO
import base64
import numpy as np

app = Flask(__name__)

@app.route('/')
def plot():
    # Create a larger figure and axis
    fig, ax = plt.subplots(figsize=(15, 7))
    fig.patch.set_facecolor('#4e4e50')
    
    # Set axis limits
    ax.set_xlim(0, 8)
    ax.set_ylim(0, 8)
    
    # Add x and y axis lines
    ax.axhline(0, color='black', linewidth=1)
    ax.axvline(0, color='black', linewidth=1)
    
    for i in range(8):
        ax.axhline(i, color='#A9A9A9', linewidth=1)
        ax.axvline(i, color='#A9A9A9', linewidth=1)
    
    # Add a dot to the middle of the plot
    middle_x = 4.5  # Middle x-coordinate
    middle_y = 4  # Middle y-coordinate
    ax.plot(middle_x, middle_y, 'x', markersize=10)
    
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

if __name__ == '__main__':
    app.run(debug=True)
