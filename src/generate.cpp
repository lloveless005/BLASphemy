#include <fstream>
#include <vector>
#include <string>
#include <iostream>
#include <omp.h>
#include <random>

#define NUM_FILES 9
#define NUM_SQUARES 6

using namespace std;

int main() {

    int status = 0;

    vector<int> matrix_dims(NUM_FILES);
    vector<string> file_names(NUM_FILES);

    // Generate file names

    for (int i = 0; i < NUM_SQUARES; i++) {
        matrix_dims[i] = 256 * (1 << i);
        file_names[i] = "input/matrix" + to_string(matrix_dims[i]) + ".bin";
    }

    for (int i = NUM_SQUARES; i < NUM_FILES; i++) {
        matrix_dims[i] = 1000 + 2000 * (i - NUM_SQUARES);
        file_names[i] = "input/matrix" + to_string(matrix_dims[i]) + ".bin";
    }

    // Find total elements

    size_t num_elements = 0;
    size_t limit = 1ULL << 32;

    for (int i = 0; i < NUM_FILES; i++) {
        num_elements += matrix_dims[i] * matrix_dims[i];
    }

    // Limit big matrix size to about 16 GB

    if (num_elements > limit) {
        cout << "That is too many elements..." << endl;
        status = 1;
    }

    if (status == 0) {

        // Open all files

        vector<ofstream> outputs(NUM_FILES);

        for (int i = 0; i < NUM_FILES; i++) {
            outputs[i].open(file_names[i], ios::binary);
            if (!outputs[i].is_open()) {
                status = 2;
                cout << "Could not open" << file_names[i] << endl;
                break;
            }
        }

        // Generate random matrices

        vector<float> big_matrix(num_elements);

        #pragma omp parallel
        {
            int tid = omp_get_thread_num();
            mt19937 gen(1337 + tid);
            uniform_real_distribution<float> dist(-1.0f, 1.0f);

            #pragma omp for
            for (size_t i = 0; i < num_elements; i++) {
                big_matrix[i] = dist(gen);
            }
        }

        // Write to files

        for (int i = 0; i < NUM_FILES; i++) {
            
        }

        // Close all files

        for (int i = 0; i < NUM_FILES; i++) {
            outputs[i].close();
        }

    }


    
    return status;

}