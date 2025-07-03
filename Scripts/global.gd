extends Node

# This is where the SBC Directives are stored
# It will be a GLOBAL Dictionary, so that any script can access it to use
# Will be used more in the custom BBCodeLink for the PageResource

var SBC_DIRECTIVES : Dictionary[StringName,String] = {
	"1.1" : "Contribuir para a sociedade e para o bem-estar humano,
reconhecendo que todas as pessoas são partes interessadas
na Computação",
	"1.2" : "Evitar danos",
	"1.3" : "Ser honesto e confiável",
	"1.4" : 'Ser justo e adotar ações não discriminatórias',
	'1.5' : 'Respeitar o trabalho necessário para produzir novas ideias,
invenções, trabalhos criativos e artefatos computacionais',
	'1.6' : 'Respeitar a privacidade',
	'1.7' : 'Honrar a confidencialidade',
	"2.1" : 'Buscar alcançar alta qualidade nos processos e produtos do
trabalho profissional',
	"2.2" : "Manter altos padrões de competência profissional, conduta e
prática ética",
	"2.3" : "Conhecer e respeitar as regras existentes relativas ao trabalho
profissional",
	'2.4' : 'Aceitar e fornecer avaliação profissional adequada',
	'2.5' : 'Fazer avaliações abrangentes e completas de sistemas
computacionais e seus impactos, incluindo análise de possíveis
riscos',
	'2.6' : 'Realizar trabalhos somente em áreas de sua competência',
	'2.7' : 'Fomentar a conscientização e entendimento do público sobre
computação, tecnologias relacionadas e suas consequências',
	'2.8' : 'Acessar recursos computacionais somente quando autorizado
ou por necessidade de garantir o bem público',
	'2.9' : 'Projetar e implementar sistemas robustos e seguros de uso',
	"3.1" : "Garantir que o bem público seja preocupação central durante
todo o trabalho do profissional da Computação",
	"3.2" : "Articular, incentivar a aceitação e avaliar o cumprimento das
responsabilidades sociais pelos membros da organização ou grupo",
	"3.3" : "Gerir pessoal e recursos para melhorar a qualidade de vida no
trabalho",
	"3.4" : "Articular, aplicar e apoiar políticas e processos que reflitam os
princípios deste código",
	"3.5" : "Criar oportunidades para os membros da organização ou grupo
crescer como profissionais",
	"3.6" : "Ter cuidado ao modificar ou encerrar a operação de sistemas",
	"3.7" : "Reconhecer e cuidar especialmente dos sistemas que se
integram à infraestrutura da sociedade",
	'4.1' : 'Apoiar, promover e respeitar os princípios deste código',
	'4.2' : 'Tratar as violações deste código como incompatíveis com os
valores da SBC enquanto associada da IFIP'
}

class PageProperties:
	var page_number : int  # Número da página (1-8)
	var stampType : bool   # true = aprovado, false = negado
	var stampPos : Vector2
	var selected_principles : Array  # Princípios selecionados pelo jogador
	var is_wrong : bool  # Se a página é inválida
	
	func _init(pageNum : int, stampType : bool, stampPos : Vector2, principles : Array = [], wrong : bool = false) -> void:
		self.page_number = pageNum
		self.stampType = stampType
		self.stampPos = stampPos
		self.selected_principles = principles
		self.is_wrong = wrong

# All the Current Round Pages
var stampedPages : Array[PageProperties]

func add_stamped_page(pageNum : int, stampType : bool, stampPos : Vector2, principles : Array = [], wrong : bool = false) -> void:
	print("Adicionando página ao Global: ", pageNum, " | Aprovada: ", stampType, " | Posição: ", stampPos)
	stampedPages.append(PageProperties.new(pageNum, stampType, stampPos, principles, wrong))
	print("Total de páginas no Global: ", stampedPages.size())

func clear_stamped_pages() -> void:
	print("Limpando páginas carimbadas")
	stampedPages.clear()

# Sistema de Pontuação
var current_score: int = 0
var total_pages_processed: int = 0
var correctly_approved_pages: int = 0
var correctly_denied_pages: int = 0
var correctly_selected_principles: int = 0

# Constantes de pontuação
const SCORE_CORRECT_APPROVAL = 10
const SCORE_CORRECT_DENIAL = 10
const SCORE_CORRECT_PRINCIPLE = 2

func reset_score() -> void:
	current_score = 0
	total_pages_processed = 0
	correctly_approved_pages = 0
	correctly_denied_pages = 0
	correctly_selected_principles = 0

func add_score_for_correct_approval() -> void:
	current_score += SCORE_CORRECT_APPROVAL
	correctly_approved_pages += 1
	total_pages_processed += 1

func add_score_for_correct_denial() -> void:
	current_score += SCORE_CORRECT_DENIAL
	correctly_denied_pages += 1
	total_pages_processed += 1

func add_score_for_correct_principles(principle_count: int) -> void:
	current_score += principle_count * SCORE_CORRECT_PRINCIPLE
	correctly_selected_principles += principle_count
	
	
