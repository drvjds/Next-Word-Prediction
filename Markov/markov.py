import re
from nltk.tokenize import word_tokenize
from collections import defaultdict, Counter
from doc import training_data

class MarkovModel:
    def __init__(self):
        self.lookup_dict = defaultdict(list)  
  
    def add_document(self, string):
        preprocessed_list = self._preprocess(string)
        pairs = self.__generate_tuple_keys(preprocessed_list)
        for pair in pairs:
            self.lookup_dict[pair[0]].append(pair[1])
        pairs2 = self.__generate_2tuple_keys(preprocessed_list)
        for pair in pairs2:
            self.lookup_dict[tuple([pair[0], pair[1]])].append(pair[2])
        pairs3 = self.__generate_3tuple_keys(preprocessed_list)
        for pair in pairs3:
            self.lookup_dict[tuple([pair[0], pair[1], pair[2]])].append(pair[3])
    
    def _preprocess(self, string):
        cleaned = re.sub(r'\W+', ' ', string).lower()
        tokenized = word_tokenize(cleaned)
        return tokenized

    def __generate_tuple_keys(self, data):
        if len(data) < 1:
            return

        for i in range(len(data) - 1):
            yield [ data[i], data[i + 1] ]
    
    def __generate_2tuple_keys(self, data):
        if len(data) < 2:
            return

        for i in range(len(data) - 2):
            yield [ data[i], data[i + 1], data[i+2] ]
        
    def __generate_3tuple_keys(self, data):
        if len(data) < 3:
            return

        for i in range(len(data) - 3):
            yield [ data[i], data[i + 1], data[i+2], data[i+3] ]
        
    def oneword(self, string):
        return Counter(self.lookup_dict[string]).most_common()[:3]

    def twowords(self, string):
        suggest = Counter(self.lookup_dict[tuple(string)]).most_common()[:3]
        if len(suggest)==0:
            return self.oneword(string[-1])
        return suggest

    def threewords(self, string):
        suggest = Counter(self.lookup_dict[tuple(string)]).most_common()[:3]
        if len(suggest)==0:
            return self.twowords(string[-2:])
        return suggest
        
    def morewords(self, string):
        return self.threewords(string[-3:])
        
    def generate_text(self, string):
        if len(self.lookup_dict) > 0:
            tokens = string.split(" ")
            if len(tokens)==1:
                print("The next word can be:", self.oneword(string))
            elif len(tokens)==2:
                print("The next word can be:", self.twowords(string.split(" ")))
            elif len(tokens)==3:
                print("The next word can be:", self.threewords(string.split(" ")))
            elif len(tokens)>3:
                print("The next word can be:", self.morewords(string.split(" ")))
        return

