import random
import pandas
import numpy as np
POPULATION_SIZE = 20
NUMB_OF_ELITE_CHROMOSOMES = 2
TOURNAMENT_POPULATION = 20
MUTATION_RATE = 0.01
CROSSOVER_RATE = 0.6
USER = 934


df = pandas.read_csv(r'C:\Users\Miltos\Desktop\u.data', encoding='utf-8', delimiter='\t', engine='python')
df.columns= ['uid', 'movieID', 'rate', 'timestamps']
df = df.drop(columns='timestamps')
table_df = df.pivot(index='uid', columns='movieID', values='rate')
table_fill = table_df.fillna(0)
table = table_fill.to_numpy()

usersRatings = table[USER]
targetChromosome=[]
constants = [0]*10
indexaUsers = [0]*10
list_of_constants_per_gen = []
overall_constant = 0
for i in range(len(table)):
    if i != USER:
        ct = np.corrcoef(usersRatings, table[i])[0, 1]
        if min(constants) < ct:
            constants[constants.index(min(constants))] = ct
            indexaUsers[indexaUsers.index(min(indexaUsers))] = i
print(constants)
print(indexaUsers)
mask = [0]*len(table[1])
sum_of_rates = [0]*len(table[1])
for k in range(len(indexaUsers)):
    sum_of_rates += table[indexaUsers[k]]
    for j in range(len(table[1])):
        if table[indexaUsers[k]][j] != 0:
            mask[j] += 1

for i in range(len(table[1])):
    if mask[i] != 0:
        targetChromosome.append(sum_of_rates[i]/mask[i])
    else:
        targetChromosome.append(sum_of_rates[i])
targetChromosome = np.round(targetChromosome)
print(targetChromosome)
TARGET_CHROMOSOME =targetChromosome

class Chromosome:
   def __init__(self):
       self.genes =[]
       self.fitness=[]
       #self.genes = random.randint(0, 1) for _ in range(len(TARGET_CHROMOSOME)))
       i=0
       while i < TARGET_CHROMOSOME.__len__():
               self.genes.append(random.randint(0, 5))
               i +=1

   def get_genes(self):
       return self.genes

   def get_fitness(self):
           self.fitness = 0
           for i in range(len(TARGET_CHROMOSOME)):
               if TARGET_CHROMOSOME[i] != 0:
                   self.genes[i] = TARGET_CHROMOSOME[i]
           ct = np.corrcoef(self.genes, TARGET_CHROMOSOME)[0,1]
           self.fitness= ct
           return self.fitness

   def __str__(self):
       return self.genes.__str__()

class Population:
    def __init__(self,size):
        self.chromosomes = []
        i=0
        while i<size:
            self.chromosomes.append(Chromosome())
            i+=1
    def get_chromosomes(self): return self.chromosomes

class GeneticAlgorithm:

    def evolve(pop):
        return GeneticAlgorithm.mutate_population(GeneticAlgorithm.crossover_population(pop))

    def crossover_population(pop):
        crossover_pop = Population(0)
        for i in range(NUMB_OF_ELITE_CHROMOSOMES):
            crossover_pop.get_chromosomes().append(pop.get_chromosomes()[i])
        i = NUMB_OF_ELITE_CHROMOSOMES
        while i< POPULATION_SIZE:
            chromosome1 = GeneticAlgorithm.select_roulete_population(pop).get_chromosomes()[0]
            chromosome2 = GeneticAlgorithm.select_roulete_population(pop).get_chromosomes()[0]
            crossover_pop.get_chromosomes().append(GeneticAlgorithm.crossover_chromosomes(chromosome1, chromosome2))
            i += 1
        return crossover_pop


    def mutate_population(pop):
        for i in range(NUMB_OF_ELITE_CHROMOSOMES, POPULATION_SIZE):
            GeneticAlgorithm.mutate_chromosome(pop.get_chromosomes()[i])
        return pop


    def crossover_chromosomes(chromosome1, chromosome2):
        crossover_chrom =Chromosome()
        for i in range(len(TARGET_CHROMOSOME)):
            if random.random() < CROSSOVER_RATE:
                if random.random() >= 0.5:
                    crossover_chrom.get_genes()[i] = chromosome1.get_genes()[i]
                else:
                    crossover_chrom.get_genes()[i] = chromosome2.get_genes()[i]
        return crossover_chrom


    def mutate_chromosome(chromosome):
        for i in range(len(TARGET_CHROMOSOME)):
            if random.random() < MUTATION_RATE:
                if random.random() < 0.5:
                    chromosome.get_genes()[i] = random.randint(0, 5)
                else:
                    chromosome.get_genes()[i] = random.randint(0, 5)
    def select_tournament_population(pop):
        tournament_pop = Population(0)
        i=0
        while i < TOURNAMENT_POPULATION:
            tournament_pop.get_chromosomes().append(pop.get_chromosomes()[random.randrange(0,POPULATION_SIZE)])
            i += 1
        tournament_pop.get_chromosomes().sort(key=lambda x: x.get_fitness(), reverse=True)
        return tournament_pop
    def select_roulete_population(pop):
        roulete_pop = Population(0)
        denominator = 0
        rand_list = [0]*POPULATION_SIZE
        constants_list = [0] * POPULATION_SIZE
        overall_constant = 0
        for i in range(POPULATION_SIZE):
            denominator += pop.get_chromosomes()[i].get_fitness()
            constants_list[i] = pop.get_chromosomes()[i].get_fitness()
            rand_list[i] = random.uniform(0, 1)

        for i in range(POPULATION_SIZE):
            constants_list[i] = constants_list[i]/denominator
        for i in range(POPULATION_SIZE):
            if i != 0:
                constants_list[i]= constants_list[i] + constants_list[i-1]
                overall_constant = constants_list[i] + constants_list[i-1]
        for i in range(POPULATION_SIZE):
            for k in range(POPULATION_SIZE):
                if(rand_list[i] < constants_list[k]):
                    roulete_pop.get_chromosomes().append(pop.get_chromosomes()[k])
                    break
        roulete_pop.get_chromosomes().sort(key=lambda x: x.get_fitness(), reverse=True)
        return roulete_pop
def printPopulation(pop, gen_number):
    print("\n---------------------------------------------------------------------------")
    print("The user is: ", USER)
    print("Generation #", gen_number, "| Fittest chromosome fitness", pop.get_chromosomes()[0].get_fitness())
    print("Target Chromosome: ", TARGET_CHROMOSOME)
    print("------------------------------------------------------------------------------")
    i=0
    for x in pop.get_chromosomes():
        print("Chromosome   #", i, " : ", x, "Fitness:", x.get_fitness())
        i +=1

population =Population(POPULATION_SIZE)
population.get_chromosomes().sort(key=lambda x: x.get_fitness(),reverse=True)
printPopulation(population,0)
generation_number=1
while  generation_number < 1000:
    population = GeneticAlgorithm.evolve(population)
    population.get_chromosomes().sort(key=lambda x: x.get_fitness(),reverse=True)
    printPopulation(population, generation_number)
    generation_number += 1

