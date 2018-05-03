#include<fstream>
#include<string>
#include<vector>
#include<iostream> //to test. wont need in final ver since outputting to file
using namespace std;

int main()
{
	char ch;
	string hold;
	vector<string> variables; //using vector of strings to hold variable names

	ofstream outFile("abc123.cpp");
	ifstream inFile("sample.txt");
	cout << "#include<iostream>" << endl << "using namespace std;" << endl << "int main()" << endl << "{" << endl; //cout to test, replace w. outfile

	while (!inFile.eof())
	{
		ch = inFile.get();
		hold = ch;
		if (isalpha(ch) || isdigit(ch)) // ignore non-alphanumerics (spaces, commas, semicolons)
		{
			ch = inFile.peek();
			while (isalpha(ch) || isdigit(ch))
			{
				ch = inFile.get();
				hold += ch;
				ch = inFile.peek();
			}
			if (hold == "VAR") // variable names, declarations follow
			{
				while (ch != ':')
				{
					if (!isalpha(ch) && !isdigit(ch))
					{
						ch = inFile.get();
					}
					while (isalpha(ch) || isdigit(ch))
					{
						hold = ch;
						while (ch != ',' && ch != ':')
						{
							ch = inFile.get();
							hold += ch;
							ch = inFile.peek();
						}
						variables.push_back(hold);
					}
				}
			}
		}

	}
	for (int i = 0; i < variables.size(); i++) //test, check contents of vector
	{
		cout << "variable " << i << ": " << variables[i] << endl;
	}
	system("Pause");
}