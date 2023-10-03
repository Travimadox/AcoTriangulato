import matlab.engine

# Start MATLAB engine
eng = matlab.engine.start_matlab()

# Call MATLAB function (e.g., sqrt)
result = eng.sqrt(16.0)
print(f'Result: {result}')

# Close MATLAB engine
eng.quit()
